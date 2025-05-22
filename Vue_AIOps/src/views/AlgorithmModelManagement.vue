<template>
  <div class="algorithm-management-container">
    <!-- 顶部操作栏 -->
    <el-card shadow="never" class="toolbar-card">
      <el-row :gutter="20">
        <el-col :span="6">
          <el-input
              v-model="searchQuery"
              placeholder="搜索算法名称/ID/标签"
              clearable
              prefix-icon="el-icon-search"
              @clear="handleSearch"
              @keyup.enter.native="handleSearch">
          </el-input>
        </el-col>
        <el-col :span="18" class="text-right">
          <el-button type="primary" icon="el-icon-plus" @click="showCreateDialog">新增算法</el-button>
          <el-button icon="el-icon-refresh" @click="fetchAlgorithmModels">刷新</el-button>
          <el-button icon="el-icon-upload" @click="showImportDialog">导入算法</el-button>
          <el-button-group style="margin-left: 10px;">
            <el-button :icon="viewType === 'card' ? 'el-icon-menu' : 'el-icon-s-grid'"
                       @click="viewType = 'card'">卡片</el-button>
            <el-button :icon="viewType === 'list' ? 'el-icon-menu' : 'el-icon-s-grid'"
                       @click="viewType = 'list'">列表</el-button>
          </el-button-group>
        </el-col>
      </el-row>
    </el-card>

    <!-- 算法类型筛选 -->
    <div class="filter-tabs">
      <el-radio-group v-model="activeFilter" @change="handleFilterChange">
        <el-radio-button label="all">全部算法</el-radio-button>
        <el-radio-button label="preset">平台预置</el-radio-button>
        <el-radio-button label="custom">我的算法</el-radio-button>
        <el-radio-button label="favorite">收藏</el-radio-button>
      </el-radio-group>
      <el-select
          v-model="activeFramework"
          placeholder="选择框架"
          clearable
          size="small"
          style="width: 150px; margin-left: 10px;"
          @change="handleFrameworkChange">
        <el-option
            v-for="framework in frameworks"
            :key="framework.value"
            :label="framework.label"
            :value="framework.value">
        </el-option>
      </el-select>
    </div>

    <!-- 卡片视图 -->
    <div v-if="viewType === 'card' && filteredAlgorithms.length > 0" class="algorithm-cards">
      <el-card
          v-for="algorithm in filteredAlgorithms"
          :key="algorithm.id"
          shadow="hover"
          class="algorithm-card">
        <div slot="header" class="card-header">
          <div class="algorithm-title">
            <span>{{ algorithm.name }}</span>
            <el-tag size="mini" :type="algorithm.isPreset ? 'success' : 'primary'">
              {{ algorithm.isPreset ? '预置' : '自定义' }}
            </el-tag>
            <el-tag size="mini" v-if="algorithm.framework" style="margin-left: 5px;">
              {{ algorithm.framework }}
            </el-tag>
          </div>
          <div class="card-actions">
            <el-button
                size="mini"
                icon="el-icon-star-off"
                circle
                :type="algorithm.isFavorite ? 'warning' : ''"
                @click.stop="toggleFavorite(algorithm)">
            </el-button>
          </div>
        </div>
        <div class="algorithm-content">
          <div class="algorithm-meta">
            <div><span class="meta-label">版本:</span> v{{ algorithm.version }}</div>
            <div><span class="meta-label">作者:</span> {{ algorithm.author || '未知' }}</div>
            <div><span class="meta-label">更新时间:</span> {{ formatTime(algorithm.updateTime) }}</div>
          </div>
          <div class="algorithm-desc">{{ algorithm.description || '暂无描述' }}</div>
          <div class="algorithm-tags">
            <el-tag
                v-for="(tag, index) in algorithm.tags.slice(0, 3)"
                :key="index"
                size="mini"
                type="info">
              {{ tag }}
            </el-tag>
            <el-tag size="mini" v-if="algorithm.tags.length > 3">+{{ algorithm.tags.length - 3 }}</el-tag>
          </div>
        </div>
        <div class="algorithm-footer">
          <el-button-group>
            <el-tooltip content="编辑算法" placement="top">
              <el-button
                  size="mini"
                  icon="el-icon-edit"
                  @click.stop="handleEdit(algorithm)"
                  :disabled="algorithm.isPreset && !hasAdminPermission">
              </el-button>
            </el-tooltip>
            <el-tooltip content="创建训练任务" placement="top">
              <el-button
                  size="mini"
                  icon="el-icon-cpu"
                  @click.stop="createTrainingTask(algorithm)">
              </el-button>
            </el-tooltip>
            <el-tooltip content="下载算法" placement="top">
              <el-button
                  size="mini"
                  icon="el-icon-download"
                  @click.stop="downloadAlgorithm(algorithm)">
              </el-button>
            </el-tooltip>
            <el-tooltip content="部署服务" placement="top">
              <el-button
                  size="mini"
                  icon="el-icon-cloudy"
                  @click.stop="deployAlgorithm(algorithm)">
              </el-button>
            </el-tooltip>
            <el-tooltip content="删除算法" placement="top">
              <el-button
                  size="mini"
                  icon="el-icon-delete"
                  type="danger"
                  @click.stop="handleDelete(algorithm)"
                  :disabled="algorithm.isPreset && !hasAdminPermission">
              </el-button>
            </el-tooltip>
          </el-button-group>
        </div>
      </el-card>
    </div>

    <!-- 列表视图 -->
    <el-table
        v-else-if="viewType === 'list' && filteredAlgorithms.length > 0"
        :data="filteredAlgorithms"
        style="width: 100%"
        border
        v-loading="loading"
        class="algorithm-table">
      <el-table-column prop="name" label="算法名称" width="180">
        <template slot-scope="{row}">
          <span class="algorithm-name">{{ row.name }}</span>
          <el-tag size="mini" :type="row.isPreset ? 'success' : 'primary'" style="margin-left: 5px;">
            {{ row.isPreset ? '预置' : '自定义' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="framework" label="框架" width="120"></el-table-column>
      <el-table-column prop="version" label="版本" width="100"></el-table-column>
      <el-table-column prop="author" label="作者" width="120"></el-table-column>
      <el-table-column prop="description" label="描述" show-overflow-tooltip></el-table-column>
      <el-table-column prop="updateTime" label="更新时间" width="180">
        <template slot-scope="{row}">
          {{ formatTime(row.updateTime) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="240" fixed="right">
        <template slot-scope="{row}">
          <el-button size="mini" icon="el-icon-edit" @click="handleEdit(row)"
                     :disabled="row.isPreset && !hasAdminPermission">编辑</el-button>
          <el-dropdown size="mini" trigger="click" @command="handleMoreAction(row, $event)">
            <el-button size="mini">
              更多<i class="el-icon-arrow-down el-icon--right"></i>
            </el-button>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="train"><i class="el-icon-cpu"></i>创建训练任务</el-dropdown-item>
              <el-dropdown-item command="download"><i class="el-icon-download"></i>下载算法</el-dropdown-item>
              <el-dropdown-item command="deploy"><i class="el-icon-cloudy"></i>部署服务</el-dropdown-item>
              <el-dropdown-item command="detail"><i class="el-icon-document"></i>查看详情</el-dropdown-item>
              <el-dropdown-item command="favorite" divided>
                <i class="el-icon-star-off"></i>{{ row.isFavorite ? '取消收藏' : '收藏' }}
              </el-dropdown-item>
              <el-dropdown-item command="delete" divided style="color: #F56C6C;"
                                :disabled="row.isPreset && !hasAdminPermission">
                <i class="el-icon-delete"></i>删除
              </el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </template>
      </el-table-column>
    </el-table>

    <!-- 空状态 -->
    <el-empty v-else description="暂无算法数据" style="margin-top: 50px;"></el-empty>

    <!-- 分页 -->
    <div class="pagination-container" v-if="filteredAlgorithms.length > 0">
      <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="currentPage"
          :page-sizes="[5, 10, 20, 30]"
          :page-size="pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="totalAlgorithms">
      </el-pagination>
    </div>

    <!-- 创建/编辑算法对话框 -->
    <el-dialog
        :title="dialogTitle"
        :visible.sync="dialogVisible"
        width="70%"
        top="5vh"
        @closed="resetForm">
      <el-form
          :model="algorithmForm"
          :rules="formRules"
          ref="algorithmForm"
          label-width="120px"
          label-position="right">
        <el-tabs v-model="activeTab" type="border-card">
          <el-tab-pane label="基本信息" name="basic">
            <el-row :gutter="20">
              <el-col :span="6">
                <el-form-item label="算法名称" prop="name">
                  <el-input v-model="algorithmForm.name" placeholder="请输入算法名称"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item label="算法ID" prop="id">
                  <el-input v-model="algorithmForm.id" :disabled="isEdit" placeholder="系统自动生成"></el-input>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item label="算法框架" prop="framework">
                  <el-select v-model="algorithmForm.framework" placeholder="请选择框架">
                    <el-option
                        v-for="framework in frameworks"
                        :key="framework.value"
                        :label="framework.label"
                        :value="framework.value">
                    </el-option>
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="6">
                <el-form-item label="算法版本" prop="version">
                  <el-input v-model="algorithmForm.version" placeholder="例如: 1.0.0"></el-input>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row :gutter="20">
              <el-col :span="8">
                <el-form-item label="算法描述" prop="description">
                  <el-input
                      type="textarea"
                      :rows="3"
                      v-model="algorithmForm.description"
                      placeholder="请输入算法功能描述">
                  </el-input>
                </el-form-item>
                <el-form-item label="算法标签">
                  <el-tag
                      v-for="tag in algorithmForm.tags"
                      :key="tag"
                      closable
                      @close="removeTag(tag)">
                    {{ tag }}
                  </el-tag>
                  <el-input
                      class="input-new-tag"
                      v-if="tagInputVisible"
                      v-model="tagInputValue"
                      ref="saveTagInput"
                      size="small"
                      @keyup.enter.native="handleTagInputConfirm"
                      @blur="handleTagInputConfirm">
                  </el-input>
                  <el-button v-else class="button-new-tag" size="small" @click="showTagInput">+ 添加标签</el-button>
                </el-form-item>
              </el-col>
              <el-col :span="8">
                <el-form-item label="Python版本" prop="pythonVersion">
                  <el-select v-model="algorithmForm.pythonVersion" placeholder="请选择Python版本">
                    <el-option
                        v-for="version in pythonVersions"
                        :key="version"
                        :label="version"
                        :value="version">
                    </el-option>
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :span="8">

              </el-col>
            </el-row>
            <el-row :gutter="20">
              <el-col :span="8">

              </el-col>
            </el-row>
            <el-row :gutter="20">
              <el-col :span="12">
                <el-form-item label="依赖配置">
                  <div class="dependency-editor">
                    <div class="dependency-toolbar">
                      <el-button size="small" icon="el-icon-plus" @click="addDependency">添加依赖</el-button>
                      <el-button size="small" icon="el-icon-refresh" @click="detectDependencies">自动检测</el-button>
                    </div>
                    <el-table
                        :data="algorithmForm.dependencies"
                        border
                        size="small"
                        style="width: 100%">
                      <el-table-column prop="name" label="包名" width="180">
                        <template slot-scope="{row}">
                          <el-input v-model="row.name" placeholder="例如: numpy"></el-input>
                        </template>
                      </el-table-column>
                      <el-table-column prop="version" label="版本" width="150">
                        <template slot-scope="{row}">
                          <el-input v-model="row.version" placeholder="例如: >=1.0.0"></el-input>
                        </template>
                      </el-table-column>
                      <el-table-column prop="source" label="源">
                        <template slot-scope="{row}">
                          <el-select v-model="row.source" placeholder="选择源">
                            <el-option label="PyPI" value="pypi"></el-option>
                            <el-option label="私有源" value="private"></el-option>
                            <el-option label="conda" value="conda"></el-option>
                          </el-select>
                        </template>
                      </el-table-column>
                      <el-table-column label="操作" width="80">
                        <template>
                          <el-button
                              size="mini"
                              type="danger"
                              icon="el-icon-delete"
                              circle
                              @click="removeDependency($index)">
                          </el-button>
                        </template>
                      </el-table-column>
                    </el-table>
                  </div>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="环境变量">
                  <div class="env-vars-editor">
                    <div class="env-toolbar">
                      <el-button size="small" icon="el-icon-plus" @click="addEnvVar">添加变量</el-button>
                    </div>
                    <el-table
                        :data="algorithmForm.envVars"
                        border
                        size="small"
                        style="width: 100%">
                      <el-table-column prop="key" label="变量名" width="180">
                        <template slot-scope="{row}">
                          <el-input v-model="row.key" placeholder="变量名称"></el-input>
                        </template>
                      </el-table-column>
                      <el-table-column prop="value" label="变量值">
                        <template slot-scope="{row}">
                          <el-input v-model="row.value" placeholder="变量值"></el-input>
                        </template>
                      </el-table-column>
                      <el-table-column label="操作" width="80">
                        <template slot-scope="{$index}">
                          <el-button
                              size="mini"
                              type="danger"
                              icon="el-icon-delete"
                              circle
                              @click="removeEnvVar($index)">
                          </el-button>
                        </template>
                      </el-table-column>
                    </el-table>
                  </div>
                </el-form-item>
              </el-col>>
            </el-row>
            <el-row :gutter="20">
              <el-col :span="12">
                <div class="param-section">
                  <div class="param-header">
                    <h3>输入参数</h3>
                    <el-button size="small" icon="el-icon-plus" @click="addInputParam">添加参数</el-button>
                  </div>
                  <el-table
                      :data="algorithmForm.inputParams"
                      border
                      size="small">
                    <el-table-column prop="name" label="参数名" width="120">
                      <template slot-scope="{row}">
                        <el-input v-model="row.name" placeholder="参数名称"></el-input>
                      </template>
                    </el-table-column>
                    <el-table-column prop="type" label="类型" width="120">
                      <template slot-scope="{row}">
                        <el-select v-model="row.type" placeholder="选择类型">
                          <el-option
                              v-for="type in paramTypes"
                              :key="type.value"
                              :label="type.label"
                              :value="type.value">
                          </el-option>
                        </el-select>
                      </template>
                    </el-table-column>
                    <el-table-column prop="required" label="必填" width="80">
                      <template slot-scope="{row}">
                        <el-checkbox v-model="row.required"></el-checkbox>
                      </template>
                    </el-table-column>
                    <el-table-column prop="description" label="描述">
                      <template slot-scope="{row}">
                        <el-input v-model="row.description" placeholder="参数描述"></el-input>
                      </template>
                    </el-table-column>
                    <el-table-column label="操作" width="80">
                      <template>
                        <el-button
                            size="mini"
                            type="danger"
                            icon="el-icon-delete"
                            circle
                            @click="removeInputParam($index)">
                        </el-button>
                      </template>
                    </el-table-column>
                  </el-table>
                </div>
              </el-col>
              <el-col :span="12">
                <div class="param-section">
                  <div class="param-header">
                    <h3>输出参数</h3>
                    <el-button size="small" icon="el-icon-plus" @click="addOutputParam">添加参数</el-button>
                  </div>
                  <el-table
                      :data="algorithmForm.outputParams"
                      border
                      size="small">
                    <el-table-column prop="name" label="参数名" width="120">
                      <template slot-scope="{row}">
                        <el-input v-model="row.name" placeholder="参数名称"></el-input>
                      </template>
                    </el-table-column>
                    <el-table-column prop="type" label="类型" width="120">
                      <template slot-scope="{row}">
                        <el-select v-model="row.type" placeholder="选择类型">
                          <el-option
                              v-for="type in paramTypes"
                              :key="type.value"
                              :label="type.label"
                              :value="type.value">
                          </el-option>
                        </el-select>
                      </template>
                    </el-table-column>
                    <el-table-column prop="description" label="描述">
                      <template slot-scope="{row}">
                        <el-input v-model="row.description" placeholder="参数描述"></el-input>
                      </template>
                    </el-table-column>
                    <el-table-column label="操作" width="80">
                      <template>
                        <el-button
                            size="mini"
                            type="danger"
                            icon="el-icon-delete"
                            circle
                            @click="removeOutputParam($index)">
                        </el-button>
                      </template>
                    </el-table-column>
                  </el-table>
                </div>
              </el-col>
            </el-row>
            <el-form-item label="执行命令">
              <el-input v-model="algorithmForm.command" placeholder="例如: python main.py --input $INPUT --output $OUTPUT">
                <template slot="prepend">$</template>
              </el-input>
            </el-form-item>
            <el-form-item label="超时设置(秒)">
              <el-input-number v-model="algorithmForm.timeout" :min="10" :max="3600"></el-input-number>
            </el-form-item>
            <el-form-item label="GPU配置">
              <el-select v-model="algorithmForm.gpuConfig" placeholder="请选择GPU配置">
                <el-option label="不使用GPU" value="none"></el-option>
                <el-option label="自动分配" value="auto"></el-option>
                <el-option label="1个GPU" value="1"></el-option>
                <el-option label="2个GPU" value="2"></el-option>
                <el-option label="4个GPU" value="4"></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="内存限制(MB)">
              <el-input-number v-model="algorithmForm.memoryLimit" :min="128" :max="32768" :step="256"></el-input-number>
            </el-form-item>
            <el-form-item label="是否公开">
              <el-switch v-model="algorithmForm.isPublic"></el-switch>
              <span style="margin-left: 10px; color: #999;">公开后其他用户可以使用此算法</span>
            </el-form-item>
          </el-tab-pane>

          <el-tab-pane label="算法代码" name="code">
            <el-form-item label="代码编辑器">
              <div class="code-editor-container">
                <div class="editor-toolbar">
                  <el-select v-model="algorithmForm.language" placeholder="选择语言" size="small" style="width: 120px;">
                    <el-option
                        v-for="lang in codeLanguages"
                        :key="lang.value"
                        :label="lang.label"
                        :value="lang.value">
                    </el-option>
                  </el-select>
                  <el-button size="small" icon="el-icon-upload" style="margin-left: 10px;">上传文件</el-button>
                </div>
                <div ref="codeEditor" class="code-editor"></div>
              </div>
            </el-form-item>
          </el-tab-pane>

<!--          <el-tab-pane label="运行环境" name="environment">-->
<!--            <el-form-item label="Python版本" prop="pythonVersion">-->
<!--              <el-select v-model="algorithmForm.pythonVersion" placeholder="请选择Python版本">-->
<!--                <el-option-->
<!--                    v-for="version in pythonVersions"-->
<!--                    :key="version"-->
<!--                    :label="version"-->
<!--                    :value="version">-->
<!--                </el-option>-->
<!--              </el-select>-->
<!--            </el-form-item>-->
<!--            <el-form-item label="依赖配置">-->
<!--              <div class="dependency-editor">-->
<!--                <div class="dependency-toolbar">-->
<!--                  <el-button size="small" icon="el-icon-plus" @click="addDependency">添加依赖</el-button>-->
<!--                  <el-button size="small" icon="el-icon-refresh" @click="detectDependencies">自动检测</el-button>-->
<!--                </div>-->
<!--                <el-table-->
<!--                    :data="algorithmForm.dependencies"-->
<!--                    border-->
<!--                    size="small"-->
<!--                    style="width: 100%">-->
<!--                  <el-table-column prop="name" label="包名" width="180">-->
<!--                    <template slot-scope="{row}">-->
<!--                      <el-input v-model="row.name" placeholder="例如: numpy"></el-input>-->
<!--                    </template>-->
<!--                  </el-table-column>-->
<!--                  <el-table-column prop="version" label="版本" width="150">-->
<!--                    <template slot-scope="{row}">-->
<!--                      <el-input v-model="row.version" placeholder="例如: >=1.0.0"></el-input>-->
<!--                    </template>-->
<!--                  </el-table-column>-->
<!--                  <el-table-column prop="source" label="源">-->
<!--                    <template slot-scope="{row}">-->
<!--                      <el-select v-model="row.source" placeholder="选择源">-->
<!--                        <el-option label="PyPI" value="pypi"></el-option>-->
<!--                        <el-option label="私有源" value="private"></el-option>-->
<!--                        <el-option label="conda" value="conda"></el-option>-->
<!--                      </el-select>-->
<!--                    </template>-->
<!--                  </el-table-column>-->
<!--                  <el-table-column label="操作" width="80">-->
<!--                    <template>-->
<!--                      <el-button-->
<!--                          size="mini"-->
<!--                          type="danger"-->
<!--                          icon="el-icon-delete"-->
<!--                          circle-->
<!--                          @click="removeDependency($index)">-->
<!--                      </el-button>-->
<!--                    </template>-->
<!--                  </el-table-column>-->
<!--                </el-table>-->
<!--              </div>-->
<!--            </el-form-item>-->
<!--            <el-form-item label="环境变量">-->
<!--              <div class="env-vars-editor">-->
<!--                <div class="env-toolbar">-->
<!--                  <el-button size="small" icon="el-icon-plus" @click="addEnvVar">添加变量</el-button>-->
<!--                </div>-->
<!--                <el-table-->
<!--                    :data="algorithmForm.envVars"-->
<!--                    border-->
<!--                    size="small"-->
<!--                    style="width: 100%">-->
<!--                  <el-table-column prop="key" label="变量名" width="180">-->
<!--                    <template slot-scope="{row}">-->
<!--                      <el-input v-model="row.key" placeholder="变量名称"></el-input>-->
<!--                    </template>-->
<!--                  </el-table-column>-->
<!--                  <el-table-column prop="value" label="变量值">-->
<!--                    <template slot-scope="{row}">-->
<!--                      <el-input v-model="row.value" placeholder="变量值"></el-input>-->
<!--                    </template>-->
<!--                  </el-table-column>-->
<!--                  <el-table-column label="操作" width="80">-->
<!--                    <template>-->
<!--                      <el-button-->
<!--                          size="mini"-->
<!--                          type="danger"-->
<!--                          icon="el-icon-delete"-->
<!--                          circle-->
<!--                          @click="removeEnvVar($index)">-->
<!--                      </el-button>-->
<!--                    </template>-->
<!--                  </el-table-column>-->
<!--                </el-table>-->
<!--              </div>-->
<!--            </el-form-item>-->
<!--          </el-tab-pane>-->

<!--          <el-tab-pane label="输入输出" name="params">-->
<!--            <el-row :gutter="20">-->
<!--              <el-col :span="12">-->
<!--                <div class="param-section">-->
<!--                  <div class="param-header">-->
<!--                    <h3>输入参数</h3>-->
<!--                    <el-button size="small" icon="el-icon-plus" @click="addInputParam">添加参数</el-button>-->
<!--                  </div>-->
<!--                  <el-table-->
<!--                      :data="algorithmForm.inputParams"-->
<!--                      border-->
<!--                      size="small">-->
<!--                    <el-table-column prop="name" label="参数名" width="120">-->
<!--                      <template slot-scope="{row}">-->
<!--                        <el-input v-model="row.name" placeholder="参数名称"></el-input>-->
<!--                      </template>-->
<!--                    </el-table-column>-->
<!--                    <el-table-column prop="type" label="类型" width="120">-->
<!--                      <template slot-scope="{row}">-->
<!--                        <el-select v-model="row.type" placeholder="选择类型">-->
<!--                          <el-option-->
<!--                              v-for="type in paramTypes"-->
<!--                              :key="type.value"-->
<!--                              :label="type.label"-->
<!--                              :value="type.value">-->
<!--                          </el-option>-->
<!--                        </el-select>-->
<!--                      </template>-->
<!--                    </el-table-column>-->
<!--                    <el-table-column prop="required" label="必填" width="80">-->
<!--                      <template slot-scope="{row}">-->
<!--                        <el-checkbox v-model="row.required"></el-checkbox>-->
<!--                      </template>-->
<!--                    </el-table-column>-->
<!--                    <el-table-column prop="description" label="描述">-->
<!--                      <template slot-scope="{row}">-->
<!--                        <el-input v-model="row.description" placeholder="参数描述"></el-input>-->
<!--                      </template>-->
<!--                    </el-table-column>-->
<!--                    <el-table-column label="操作" width="80">-->
<!--                      <template>-->
<!--                        <el-button-->
<!--                            size="mini"-->
<!--                            type="danger"-->
<!--                            icon="el-icon-delete"-->
<!--                            circle-->
<!--                            @click="removeInputParam($index)">-->
<!--                        </el-button>-->
<!--                      </template>-->
<!--                    </el-table-column>-->
<!--                  </el-table>-->
<!--                </div>-->
<!--              </el-col>-->
<!--              <el-col :span="12">-->
<!--                <div class="param-section">-->
<!--                  <div class="param-header">-->
<!--                    <h3>输出参数</h3>-->
<!--                    <el-button size="small" icon="el-icon-plus" @click="addOutputParam">添加参数</el-button>-->
<!--                  </div>-->
<!--                  <el-table-->
<!--                      :data="algorithmForm.outputParams"-->
<!--                      border-->
<!--                      size="small">-->
<!--                    <el-table-column prop="name" label="参数名" width="120">-->
<!--                      <template slot-scope="{row}">-->
<!--                        <el-input v-model="row.name" placeholder="参数名称"></el-input>-->
<!--                      </template>-->
<!--                    </el-table-column>-->
<!--                    <el-table-column prop="type" label="类型" width="120">-->
<!--                      <template slot-scope="{row}">-->
<!--                        <el-select v-model="row.type" placeholder="选择类型">-->
<!--                          <el-option-->
<!--                              v-for="type in paramTypes"-->
<!--                              :key="type.value"-->
<!--                              :label="type.label"-->
<!--                              :value="type.value">-->
<!--                          </el-option>-->
<!--                        </el-select>-->
<!--                      </template>-->
<!--                    </el-table-column>-->
<!--                    <el-table-column prop="description" label="描述">-->
<!--                      <template slot-scope="{row}">-->
<!--                        <el-input v-model="row.description" placeholder="参数描述"></el-input>-->
<!--                      </template>-->
<!--                    </el-table-column>-->
<!--                    <el-table-column label="操作" width="80">-->
<!--                      <template>-->
<!--                        <el-button-->
<!--                            size="mini"-->
<!--                            type="danger"-->
<!--                            icon="el-icon-delete"-->
<!--                            circle-->
<!--                            @click="removeOutputParam($index)">-->
<!--                        </el-button>-->
<!--                      </template>-->
<!--                    </el-table-column>-->
<!--                  </el-table>-->
<!--                </div>-->
<!--              </el-col>-->
<!--            </el-row>-->
<!--          </el-tab-pane>-->

<!--          <el-tab-pane label="高级配置" name="advanced">-->
<!--            <el-form-item label="执行命令">-->
<!--              <el-input v-model="algorithmForm.command" placeholder="例如: python main.py &#45;&#45;input $INPUT &#45;&#45;output $OUTPUT">-->
<!--                <template slot="prepend">$</template>-->
<!--              </el-input>-->
<!--            </el-form-item>-->
<!--            <el-form-item label="超时设置(秒)">-->
<!--              <el-input-number v-model="algorithmForm.timeout" :min="10" :max="3600"></el-input-number>-->
<!--            </el-form-item>-->
<!--            <el-form-item label="GPU配置">-->
<!--              <el-select v-model="algorithmForm.gpuConfig" placeholder="请选择GPU配置">-->
<!--                <el-option label="不使用GPU" value="none"></el-option>-->
<!--                <el-option label="自动分配" value="auto"></el-option>-->
<!--                <el-option label="1个GPU" value="1"></el-option>-->
<!--                <el-option label="2个GPU" value="2"></el-option>-->
<!--                <el-option label="4个GPU" value="4"></el-option>-->
<!--              </el-select>-->
<!--            </el-form-item>-->
<!--            <el-form-item label="内存限制(MB)">-->
<!--              <el-input-number v-model="algorithmForm.memoryLimit" :min="128" :max="32768" :step="256"></el-input-number>-->
<!--            </el-form-item>-->
<!--            <el-form-item label="是否公开">-->
<!--              <el-switch v-model="algorithmForm.isPublic"></el-switch>-->
<!--              <span style="margin-left: 10px; color: #999;">公开后其他用户可以使用此算法</span>-->
<!--            </el-form-item>-->
<!--          </el-tab-pane>-->
        </el-tabs>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitForm">确 定</el-button>
      </span>
    </el-dialog>

    <!-- 导入算法对话框 -->
    <el-dialog
        title="导入算法"
        :visible.sync="importDialogVisible"
        width="50%">
      <el-upload
          class="upload-demo"
          drag
          action="/api/algorithm/import"
          multiple
          :on-success="handleImportSuccess"
          :before-upload="beforeImportUpload">
        <i class="el-icon-upload"></i>
        <div class="el-upload__text">将算法包拖到此处，或<em>点击上传</em></div>
        <div class="el-upload__tip" slot="tip">支持.zip/.tar.gz格式的算法包，包含完整的代码和配置文件</div>
      </el-upload>
    </el-dialog>

    <!-- 训练任务对话框 -->
    <el-dialog
        :title="`创建训练任务 - ${selectedAlgorithm ? selectedAlgorithm.name : ''}`"
        :visible.sync="trainingDialogVisible"
        width="60%">
      <training-task-form
          v-if="trainingDialogVisible"
          :algorithm="selectedAlgorithm"
          @submit="handleTrainingSubmit"
          @cancel="trainingDialogVisible = false">
      </training-task-form>
    </el-dialog>

    <!-- 部署服务对话框 -->
    <el-dialog
        :title="`部署算法服务 - ${selectedAlgorithm ? selectedAlgorithm.name : ''}`"
        :visible.sync="deployDialogVisible"
        width="60%">
      <deployment-form
          v-if="deployDialogVisible"
          :algorithm="selectedAlgorithm"
          @submit="handleDeploySubmit"
          @cancel="deployDialogVisible = false">
      </deployment-form>
    </el-dialog>
  </div>
</template>

<script>
import { getAlgorithmModels, saveAlgorithmModel, deleteAlgorithmModel } from '@/api/algorithm'


export default {
  name: 'AlgorithmModelManagement',
  data() {
    return {
      // 搜索和分页
      searchQuery: '',
      currentPage: 1,
      pageSize: 10,
      totalAlgorithms: 0,

      // 视图控制
      viewType: 'card',
      loading: false,

      // 筛选条件
      activeFilter: 'all',
      activeFramework: '',
      frameworks: [
        { label: 'TensorFlow', value: 'tensorflow' },
        { label: 'PyTorch', value: 'pytorch' },
        { label: 'Scikit-learn', value: 'sklearn' },
        { label: 'XGBoost', value: 'xgboost' },
        { label: 'Keras', value: 'keras' }
      ],

      // 算法数据
      algorithms: [],
      selectedAlgorithm: null,

      // 对话框控制
      dialogVisible: false,
      dialogTitle: '新增算法模型',
      isEdit: false,
      activeTab: 'basic',
      importDialogVisible: false,
      trainingDialogVisible: false,
      deployDialogVisible: false,

      // 算法表单
      algorithmForm: {
        id: '',
        name: '',
        framework: '',
        version: '1.0.0',
        description: '',
        tags: [],
        language: 'python',
        code: '',
        pythonVersion: '3.8',
        dependencies: [],
        envVars: [],
        inputParams: [],
        outputParams: [],
        command: '',
        timeout: 300,
        gpuConfig: 'none',
        memoryLimit: 2048,
        isPublic: false,
        isPreset: false
      },

      // 表单验证规则
      formRules: {
        name: [
          { required: true, message: '请输入算法名称', trigger: 'blur' }
        ],
        framework: [
          { required: true, message: '请选择算法框架', trigger: 'change' }
        ],
        version: [
          { required: true, message: '请输入版本号', trigger: 'blur' },
          { pattern: /^\d+\.\d+\.\d+$/, message: '版本号格式应为x.x.x', trigger: 'blur' }
        ],
        pythonVersion: [
          { required: true, message: '请选择Python版本', trigger: 'change' }
        ]
      },

      // 标签输入
      tagInputVisible: false,
      tagInputValue: '',

      // 代码编辑器相关
      codeEditor: null,
      codeLanguages: [
        { label: 'Python', value: 'python' },
        { label: 'R', value: 'r' },
        { label: 'Java', value: 'java' },
        { label: 'C++', value: 'cpp' }
      ],

      // Python版本选项
      pythonVersions: ['3.6', '3.7', '3.8', '3.9', '3.10'],

      // 参数类型选项
      paramTypes: [
        { label: '字符串', value: 'string' },
        { label: '数值', value: 'number' },
        { label: '布尔值', value: 'boolean' },
        { label: '数组', value: 'array' },
        { label: '对象', value: 'object' },
        { label: '文件', value: 'file' },
        { label: '任意类型', value: 'any' }
      ],

      // 用户权限
      hasAdminPermission: false
    }
  },
  computed: {
    filteredAlgorithms() {
      let result = this.algorithms

      // 按类型筛选
      if (this.activeFilter === 'preset') {
        result = result.filter(a => a.isPreset)
      } else if (this.activeFilter === 'custom') {
        result = result.filter(a => !a.isPreset)
      } else if (this.activeFilter === 'favorite') {
        result = result.filter(a => a.isFavorite)
      }

      // 按框架筛选
      if (this.activeFramework) {
        result = result.filter(a => a.framework === this.activeFramework)
      }

      // 按搜索词筛选
      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase()
        result = result.filter(a =>
            a.name.toLowerCase().includes(query) ||
            a.id.toLowerCase().includes(query) ||
            (a.description && a.description.toLowerCase().includes(query)) ||
            (a.tags && a.tags.some(tag => tag.toLowerCase().includes(query)))
        )
      }

      // 分页
      // eslint-disable-next-line vue/no-side-effects-in-computed-properties
      this.totalAlgorithms = result.length
      const start = (this.currentPage - 1) * this.pageSize
      const end = start + this.pageSize
      return result.slice(start, end)
    }
  },
  created() {
    this.fetchAlgorithmModels()
    this.checkUserPermission()
  },
  mounted() {
    // 初始化代码编辑器
    // this.initCodeEditor()
  },
  beforeDestroy() {
    if (this.codeEditor) {
      this.codeEditor.dispose()
    }
  },
  methods: {
    // 获取算法列表
    async fetchAlgorithmModels() {
      this.loading = true
      try {
        const response = await getAlgorithmModels()
        this.algorithms = response.data
        this.totalAlgorithms = this.algorithms.length
      } catch (error) {
        console.error('获取算法列表失败:', error)
        this.$message.error('获取算法列表失败')
      } finally {
        this.loading = false
      }
    },

    // 检查用户权限
    checkUserPermission() {
      // 实际项目中应从用户信息中获取权限
      this.hasAdminPermission = true
    },



    // 显示创建对话框
    showCreateDialog() {
      this.dialogTitle = '新增算法模型'
      this.isEdit = false
      this.dialogVisible = true
      this.activeTab = 'basic'

      // 重置表单
      this.resetForm()

      // 设置默认值
      this.algorithmForm = {
        id: this.generateAlgorithmId(),
        name: '',
        framework: '',
        version: '1.0.0',
        description: '',
        tags: [],
        language: 'python',
        code: '# 在这里编写你的算法代码\n\ndef train(input_data):\n    # 训练逻辑\n    pass\n\ndef predict(model, input_data):\n    # 预测逻辑\n    pass',
        pythonVersion: '3.8',
        dependencies: [
          { name: 'numpy', version: '>=1.0.0', source: 'pypi' }
        ],
        envVars: [],
        inputParams: [
          { name: 'input_data', type: 'file', required: true, description: '输入数据文件' }
        ],
        outputParams: [
          { name: 'output_model', type: 'file', description: '输出模型文件' }
        ],
        command: 'python main.py --input $INPUT --output $OUTPUT',
        timeout: 300,
        gpuConfig: 'none',
        memoryLimit: 2048,
        isPublic: false,
        isPreset: false
      }

      // 初始化编辑器内容
      this.$nextTick(() => {
        if (this.codeEditor) {
          this.codeEditor.setValue(this.algorithmForm.code)
        }
      })
    },

    // 生成算法ID
    generateAlgorithmId() {
      return 'algo-' + Math.random().toString(36).substr(2, 8)
    },

    // 显示编辑对话框
    handleEdit(algorithm) {
      this.dialogTitle = '编辑算法模型'
      this.isEdit = true
      this.selectedAlgorithm = algorithm
      this.algorithmForm = JSON.parse(JSON.stringify(algorithm))
      this.dialogVisible = true
      this.activeTab = 'basic'

      // 更新编辑器内容
      this.$nextTick(() => {
        if (this.codeEditor) {
          this.codeEditor.setValue(this.algorithmForm.code)
          this.updateEditorLanguage()
        }
      })
    },

    // 显示导入对话框
    showImportDialog() {
      this.importDialogVisible = true
    },

    // 创建训练任务
    createTrainingTask(algorithm) {
      this.selectedAlgorithm = algorithm
      this.trainingDialogVisible = true
    },

    // 处理训练任务提交
    handleTrainingSubmit(taskData) {
      console.log('创建训练任务:', taskData)
      this.$message.success('训练任务创建成功')
      this.trainingDialogVisible = false
    },

    // 部署算法
    deployAlgorithm(algorithm) {
      this.selectedAlgorithm = algorithm
      this.deployDialogVisible = true
    },

    // 处理部署提交
    handleDeploySubmit(deployData) {
      console.log('部署算法:', deployData)
      this.$message.success('算法部署成功')
      this.deployDialogVisible = false
    },

    // 下载算法
    downloadAlgorithm(algorithm) {
      console.log('下载算法:', algorithm.id)
      this.$message.success(`开始下载算法 ${algorithm.name}`)
      // 实际项目中这里应该调用下载API
    },

    // 删除算法
    handleDelete(algorithm) {
      this.$confirm(`确定要删除算法 "${algorithm.name}" 吗?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          await deleteAlgorithmModel(algorithm.id)
          this.$message.success('算法删除成功')
          this.fetchAlgorithmModels()
        } catch (error) {
          console.error('删除算法失败:', error)
          this.$message.error('删除算法失败')
        }
      }).catch(() => {})
    },

    // 切换收藏状态
    toggleFavorite(algorithm) {
      algorithm.isFavorite = !algorithm.isFavorite
      this.$message.success(algorithm.isFavorite ? '已添加到收藏' : '已取消收藏')
      // 实际项目中这里应该调用API更新收藏状态
    },

    // 处理更多操作
    handleMoreAction(algorithm, command) {
      switch (command) {
        case 'train':
          this.createTrainingTask(algorithm)
          break
        case 'download':
          this.downloadAlgorithm(algorithm)
          break
        case 'deploy':
          this.deployAlgorithm(algorithm)
          break
        case 'detail':
          this.handleEdit(algorithm)
          break
        case 'favorite':
          this.toggleFavorite(algorithm)
          break
        case 'delete':
          this.handleDelete(algorithm)
          break
      }
    },

    // 标签管理
    showTagInput() {
      this.tagInputVisible = true
      this.$nextTick(() => {
        this.$refs.saveTagInput.$refs.input.focus()
      })
    },

    handleTagInputConfirm() {
      const inputValue = this.tagInputValue.trim()
      if (inputValue && !this.algorithmForm.tags.includes(inputValue)) {
        this.algorithmForm.tags.push(inputValue)
      }
      this.tagInputVisible = false
      this.tagInputValue = ''
    },

    removeTag(tag) {
      this.algorithmForm.tags = this.algorithmForm.tags.filter(t => t !== tag)
    },

    // 依赖管理
    addDependency() {
      this.algorithmForm.dependencies.push({
        name: '',
        version: '',
        source: 'pypi'
      })
    },

    removeDependency(index) {
      this.algorithmForm.dependencies.splice(index, 1)
    },

    detectDependencies() {
      this.$message.info('正在自动检测依赖...')
      // 模拟检测结果
      setTimeout(() => {
        this.algorithmForm.dependencies = [
          { name: 'numpy', version: '>=1.0.0', source: 'pypi' },
          { name: 'pandas', version: '>=1.0.0', source: 'pypi' },
          { name: this.algorithmForm.framework, version: 'latest', source: 'pypi' }
        ].filter(dep => dep.name)
        this.$message.success('依赖检测完成')
      }, 1000)
    },

    // 环境变量管理
    addEnvVar() {
      this.algorithmForm.envVars.push({
        key: '',
        value: ''
      })
    },

    removeEnvVar(index) {
      this.algorithmForm.envVars.splice(index, 1)
    },

    // 参数管理
    addInputParam() {
      this.algorithmForm.inputParams.push({
        name: '',
        type: 'any',
        required: true,
        description: ''
      })
    },

    removeInputParam(index) {
      this.algorithmForm.inputParams.splice(index, 1)
    },

    addOutputParam() {
      this.algorithmForm.outputParams.push({
        name: '',
        type: 'any',
        description: ''
      })
    },

    removeOutputParam(index) {
      this.algorithmForm.outputParams.splice(index, 1)
    },

    // 表单提交
    submitForm() {
      this.$refs.algorithmForm.validate(async valid => {
        if (!valid) {
          this.$message.warning('请填写完整的表单信息')
          return
        }

        try {
          const algorithmData = JSON.parse(JSON.stringify(this.algorithmForm))

          if (this.isEdit) {
            await saveAlgorithmModel(algorithmData)
            this.$message.success('算法更新成功')
          } else {
            await saveAlgorithmModel(algorithmData)
            this.$message.success('算法添加成功')
          }

          this.dialogVisible = false
          this.fetchAlgorithmModels()
        } catch (error) {
          console.error('保存算法失败:', error)
          this.$message.error('保存算法失败')
        }
      })
    },

    // 重置表单
    resetForm() {
      this.$refs.algorithmForm.resetFields()
      this.algorithmForm = {
        id: '',
        name: '',
        framework: '',
        version: '1.0.0',
        description: '',
        tags: [],
        language: 'python',
        code: '',
        pythonVersion: '3.8',
        dependencies: [],
        envVars: [],
        inputParams: [],
        outputParams: [],
        command: '',
        timeout: 300,
        gpuConfig: 'none',
        memoryLimit: 2048,
        isPublic: false,
        isPreset: false
      }
    },

    // 导入算法
    beforeImportUpload(file) {
      const isZip = file.type === 'application/zip' || file.name.endsWith('.zip')
      const isTarGz = file.name.endsWith('.tar.gz')
      if (!isZip && !isTarGz) {
        this.$message.error('只能上传ZIP或TAR.GZ格式的算法包')
        return false
      }
      return true
    },

    handleImportSuccess() {
      this.$message.success('算法导入成功')
      this.importDialogVisible = false
      this.fetchAlgorithmModels()
    },

    // 时间格式化
    formatTime(time) {
      return new Date(time).toLocaleString()
    },

    // 分页
    handleSizeChange(val) {
      this.pageSize = val
    },

    handleCurrentChange(val) {
      this.currentPage = val
    },

    handleSearch() {
      this.currentPage = 1
    },

    // 筛选条件变化
    handleFilterChange() {
      this.currentPage = 1
    },

    handleFrameworkChange() {
      this.currentPage = 1
    }
  }
}
</script>

<style scoped>
.algorithm-management-container {
  padding: 20px;
}

.toolbar-card {
  margin-bottom: 20px;
}

.text-right {
  text-align: right;
}

.filter-tabs {
  margin-bottom: 20px;
  display: flex;
  align-items: center;
}

.algorithm-cards {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

.algorithm-card {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.algorithm-title {
  display: flex;
  align-items: center;
}

.card-actions {
  margin-left: 10px;
}

.algorithm-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.algorithm-meta {
  margin-bottom: 10px;
  font-size: 13px;
  color: #666;
}

.meta-label {
  color: #999;
  margin-right: 5px;
}

.algorithm-desc {
  flex: 1;
  margin-bottom: 15px;
  color: #666;
  font-size: 14px;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.algorithm-tags {
  margin-bottom: 15px;
}

.algorithm-footer {
  text-align: right;
}

.pagination-container {
  margin-top: 20px;
  text-align: center;
}

.code-editor-container {
  border: 1px solid #dcdfe6;
  border-radius: 4px;
}

.editor-toolbar {
  padding: 5px 10px;
  background: #f5f7fa;
  border-bottom: 1px solid #dcdfe6;
  display: flex;
  align-items: center;
}

.code-editor {
  height: 400px;
}

.dependency-editor, .env-vars-editor {
  margin-bottom: 20px;
}

.dependency-toolbar, .env-toolbar {
  margin-bottom: 10px;
}

.param-section {
  margin-bottom: 20px;
}

.param-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.param-header h3 {
  margin: 0;
  font-size: 16px;
  color: #333;
}

.el-tag + .el-tag {
  margin-left: 5px;
}

.button-new-tag {
  margin-left: 5px;
  height: 26px;
  line-height: 22px;
}

.input-new-tag {
  width: 90px;
  margin-left: 5px;
  vertical-align: bottom;
}

.algorithm-table {
  margin-bottom: 20px;
}

.algorithm-name {
  font-weight: bold;
}

.upload-demo {
  text-align: center;
}
</style>
