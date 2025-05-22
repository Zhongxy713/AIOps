<template>
  <div class="algorithm-components-container">
    <!-- 顶部操作栏 -->
    <el-card shadow="never" class="toolbar-card">
      <el-row :gutter="20">
        <el-col :span="6">
          <el-input
              v-model="searchQuery"
              placeholder="搜索组件名称/ID"
              clearable
              prefix-icon="el-icon-search"
              @clear="handleSearch"
              @keyup.enter.native="handleSearch">
          </el-input>
        </el-col>
        <el-col :span="18" class="text-right">
          <el-button type="primary" icon="el-icon-plus" @click="handleCreate">新增组件</el-button>
          <el-button icon="el-icon-refresh" @click="fetchComponents">刷新</el-button>
          <el-button :icon="isCardView ? 'el-icon-menu' : 'el-icon-s-grid'"
                     @click="isCardView = !isCardView">
            {{ isCardView ? '列表视图' : '卡片视图' }}
          </el-button>
        </el-col>
      </el-row>
    </el-card>

    <!-- 分类标签 -->
    <div class="category-tabs">
      <el-tag
          v-for="tag in categories"
          :key="tag.id"
          :type="activeCategory === tag.id ? '' : 'info'"
          @click="activeCategory = tag.id"
          class="category-tag">
        {{ tag.name }} ({{ getCategoryCount(tag.id) }})
      </el-tag>
      <el-button size="mini" icon="el-icon-edit" @click="showCategoryDialog"></el-button>
    </div>

    <!-- 组件展示区域 -->
    <template v-if="filteredComponents.length > 0">
      <!-- 卡片视图 -->
      <div v-if="isCardView" class="component-cards">
        <el-card
            v-for="component in filteredComponents"
            :key="component.id"
            shadow="hover"
            class="component-card">
          <div slot="header" class="clearfix">
            <span class="component-title">{{ component.name }}</span>
            <el-tag size="mini" :type="getComponentType(component.category)">
              {{ getCategoryName(component.category) }}
            </el-tag>
          </div>
          <div class="component-content">
            <div class="component-meta">
              <div><span class="meta-label">组件ID:</span> {{ component.id }}</div>
              <div><span class="meta-label">版本:</span> v{{ component.version }}</div>
              <div><span class="meta-label">创建时间:</span> {{ component.createTime }}</div>
            </div>
            <div class="component-desc">{{ component.description || '暂无描述' }}</div>
            <div class="component-params">
              <el-tag
                  v-for="(input, index) in component.inputs.slice(0, 3)"
                  :key="'input-'+index"
                  size="mini"
                  type="info">
                输入: {{ input.name }}
              </el-tag>
              <el-tag
                  v-for="(output, index) in component.outputs.slice(0, 3)"
                  :key="'output-'+index"
                  size="mini"
                  type="success">
                输出: {{ output.name }}
              </el-tag>
              <el-tag v-if="component.inputs.length > 3" size="mini">+{{ component.inputs.length - 3 }}...</el-tag>
            </div>
          </div>
          <div class="component-actions">
            <el-button size="mini" @click.stop="handleEdit(component)">编辑</el-button>
            <el-button size="mini" @click.stop="handlePreview(component)">预览</el-button>
            <el-button size="mini" type="danger" @click.stop="handleDelete(component)">删除</el-button>
          </div>
        </el-card>
      </div>

      <!-- 列表视图 -->
      <el-table
          v-else
          :data="filteredComponents"
          style="width: 100%"
          border
          v-loading="loading">
        <el-table-column prop="name" label="组件名称" width="180">
          <template slot-scope="{row}">
            <span class="component-name">{{ row.name }}</span>
            <el-tag size="mini" :type="getComponentType(row.category)" style="margin-left: 5px;">
              {{ getCategoryName(row.category) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="id" label="组件ID" width="200"></el-table-column>
        <el-table-column label="输入参数" width="180">
          <template slot-scope="{row}">
            <el-popover
                placement="top-start"
                width="300"
                trigger="hover">
              <div v-for="(input, index) in row.inputs" :key="index">
                {{ input.name }}: <em>{{ input.type }}</em>
                <span v-if="input.required" style="color: #F56C6C">*</span>
              </div>
              <el-button slot="reference" size="mini">查看({{ row.inputs.length }})</el-button>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column label="输出参数" width="180">
          <template slot-scope="{row}">
            <el-popover
                placement="top-start"
                width="300"
                trigger="hover">
              <div v-for="(output, index) in row.outputs" :key="index">
                {{ output.name }}: <em>{{ output.type }}</em>
              </div>
              <el-button slot="reference" size="mini">查看({{ row.outputs.length }})</el-button>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column prop="version" label="版本" width="100"></el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180"></el-table-column>
        <el-table-column label="操作" width="220" fixed="right">
          <template slot-scope="{row}">
            <el-button size="mini" @click="handleEdit(row)">编辑</el-button>
            <el-button size="mini" @click="handlePreview(row)">预览</el-button>
            <el-button size="mini" type="danger" @click="handleDelete(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </template>

    <!-- 空状态 -->
    <el-empty v-else description="暂无组件数据" style="margin-top: 50px;"></el-empty>

    <!-- 分页 -->
    <div class="pagination-container" v-if="filteredComponents.length > 0">
      <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="currentPage"
          :page-sizes="[5, 10, 20, 30]"
          :page-size="pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="totalComponents">
      </el-pagination>
    </div>

    <!-- 组件编辑/新增对话框 -->
    <el-dialog
        :title="dialogTitle"
        :visible.sync="dialogVisible"
        width="60%"
        top="5vh"
        @closed="resetForm">
      <el-form
          :model="componentForm"
          :rules="formRules"
          ref="componentForm"
          label-width="120px"
          label-position="right">
        <el-tabs v-model="activeTab">
          <el-tab-pane label="基本信息" name="basic">
            <el-form-item label="组件名称" prop="name">
              <el-input v-model="componentForm.name" placeholder="请输入组件名称"></el-input>
            </el-form-item>
            <el-form-item label="组件ID" prop="id">
              <el-input v-model="componentForm.id" :disabled="isEdit" placeholder="请输入唯一组件ID"></el-input>
            </el-form-item>
            <el-form-item label="组件分类" prop="category">
              <el-select v-model="componentForm.category" placeholder="请选择分类">
                <el-option
                    v-for="category in categories"
                    :key="category.id"
                    :label="category.name"
                    :value="category.id">
                </el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="组件版本" prop="version">
              <el-input v-model="componentForm.version" placeholder="例如: 1.0.0"></el-input>
            </el-form-item>
            <el-form-item label="组件描述" prop="description">
              <el-input
                  type="textarea"
                  :rows="3"
                  v-model="componentForm.description"
                  placeholder="请输入组件功能描述">
              </el-input>
            </el-form-item>
          </el-tab-pane>

          <el-tab-pane label="输入参数" name="inputs">
            <div class="param-actions">
              <el-button size="small" type="primary" icon="el-icon-plus" @click="addParam('input')">
                添加输入参数
              </el-button>
            </div>
            <el-table
                :data="componentForm.inputs"
                border
                size="small"
                style="width: 100%">
              <el-table-column prop="name" label="参数名" width="180">
                <template slot-scope="{row}">
                  <el-input v-model="row.name" placeholder="参数名称"></el-input>
                </template>
              </el-table-column>
              <el-table-column prop="type" label="类型" width="150">
                <template slot-scope="{row}">
                  <el-select v-model="row.type" placeholder="选择类型">
                    <el-option
                        v-for="type in paramTypes"
                        :key="type"
                        :label="type"
                        :value="type">
                    </el-option>
                  </el-select>
                </template>
              </el-table-column>
              <el-table-column prop="description" label="描述">
                <template slot-scope="{row}">
                  <el-input v-model="row.description" placeholder="参数描述"></el-input>
                </template>
              </el-table-column>
              <el-table-column prop="required" label="必填" width="80">
                <template slot-scope="{row}">
                  <el-checkbox v-model="row.required"></el-checkbox>
                </template>
              </el-table-column>
              <el-table-column label="操作" width="80">
                <template>
                  <el-button
                      size="mini"
                      type="danger"
                      icon="el-icon-delete"
                      circle
                      @click="removeParam('input', $index)">
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </el-tab-pane>

          <el-tab-pane label="输出参数" name="outputs">
            <div class="param-actions">
              <el-button size="small" type="primary" icon="el-icon-plus" @click="addParam('output')">
                添加输出参数
              </el-button>
            </div>
            <el-table
                :data="componentForm.outputs"
                border
                size="small"
                style="width: 100%">
              <el-table-column prop="name" label="参数名" width="180">
                <template slot-scope="{row}">
                  <el-input v-model="row.name" placeholder="参数名称"></el-input>
                </template>
              </el-table-column>
              <el-table-column prop="type" label="类型" width="150">
                <template slot-scope="{row}">
                  <el-select v-model="row.type" placeholder="选择类型">
                    <el-option
                        v-for="type in paramTypes"
                        :key="type"
                        :label="type"
                        :value="type">
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
                      @click="removeParam('output', $index)">
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </el-tab-pane>

          <el-tab-pane label="高级配置" name="advanced">
            <el-form-item label="组件图标">
              <el-upload
                  class="avatar-uploader"
                  action="https://jsonplaceholder.typicode.com/posts/"
                  :show-file-list="false"
                  :on-success="handleIconSuccess"
                  :before-upload="beforeIconUpload">
                <img v-if="componentForm.icon" :src="componentForm.icon" class="component-icon">
                <i v-else class="el-icon-plus avatar-uploader-icon"></i>
              </el-upload>
            </el-form-item>
            <el-form-item label="依赖项">
              <el-select
                  v-model="componentForm.dependencies"
                  multiple
                  filterable
                  allow-create
                  default-first-option
                  placeholder="请输入依赖项">
                <el-option
                    v-for="item in dependencyOptions"
                    :key="item"
                    :label="item"
                    :value="item">
                </el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="执行超时(秒)">
              <el-input-number v-model="componentForm.timeout" :min="1" :max="3600"></el-input-number>
            </el-form-item>
            <el-form-item label="容器镜像">
              <el-select
                  v-model="componentForm.dependencies"
                  multiple
                  filterable
                  allow-create
                  default-first-option
                  placeholder="请选择模型镜像库中对应镜像名称">
                <el-option
                    v-for="item in dependencyOptions"
                    :key="item"
                    :label="item"
                    :value="item">
                </el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="是否启用">
              <el-switch v-model="componentForm.enabled"></el-switch>
            </el-form-item>
          </el-tab-pane>
        </el-tabs>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitForm">确 定</el-button>
      </span>
    </el-dialog>

    <!-- 分类管理对话框 -->
    <el-dialog
        title="分类管理"
        :visible.sync="categoryDialogVisible"
        width="40%">
      <div class="category-manage">
        <el-table
            :data="categories"
            border
            size="small"
            style="width: 100%">
          <el-table-column prop="name" label="分类名称">
            <template slot-scope="{row}">
              <el-input v-if="row.editing" v-model="row.name"></el-input>
              <span v-else>{{ row.name }}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="150">
            <template slot-scope="{row, $index}">
              <template v-if="row.editing">
                <el-button size="mini" type="success" @click="saveCategory(row, $index)">保存</el-button>
                <el-button size="mini" @click="cancelEditCategory(row, $index)">取消</el-button>
              </template>
              <template v-else>
                <el-button size="mini" @click="editCategory(row, $index)">编辑</el-button>
                <el-button
                    size="mini"
                    type="danger"
                    @click="deleteCategory($index)"
                    :disabled="row.id === 'default'">
                  删除
                </el-button>
              </template>
            </template>
          </el-table-column>
        </el-table>
        <div class="add-category">
          <el-input
              v-model="newCategoryName"
              placeholder="新分类名称"
              style="width: 200px; margin-right: 10px;">
          </el-input>
          <el-button type="primary" @click="addCategory">添加分类</el-button>
        </div>
      </div>
    </el-dialog>

    <!-- 组件预览对话框 -->
    <el-dialog
        :title="previewTitle"
        :visible.sync="previewVisible"
        width="70%"
        top="5vh">
      <div class="component-preview">
        <div class="preview-header">
          <div class="preview-title">{{ previewData.name }}</div>
          <div class="preview-meta">
            <el-tag size="small">{{ getCategoryName(previewData.category) }}</el-tag>
            <span class="preview-version">v{{ previewData.version }}</span>
          </div>
        </div>
        <div class="preview-content">
          <div class="preview-description">
            <h3>组件描述</h3>
            <p>{{ previewData.description || '暂无描述' }}</p>
          </div>
          <el-row :gutter="20">
            <el-col :span="12">
              <div class="preview-section">
                <h3>输入参数</h3>
                <el-table
                    :data="previewData.inputs"
                    border
                    size="small">
                  <el-table-column prop="name" label="参数名" width="150"></el-table-column>
                  <el-table-column prop="type" label="类型" width="100"></el-table-column>
                  <el-table-column prop="description" label="描述"></el-table-column>
                  <el-table-column prop="required" label="必填" width="80">
                    <template slot-scope="{row}">
                      <el-tag v-if="row.required" size="mini" type="danger">是</el-tag>
                      <el-tag v-else size="mini" type="info">否</el-tag>
                    </template>
                  </el-table-column>
                </el-table>
              </div>
            </el-col>
            <el-col :span="12">
              <div class="preview-section">
                <h3>输出参数</h3>
                <el-table
                    :data="previewData.outputs"
                    border
                    size="small">
                  <el-table-column prop="name" label="参数名" width="150"></el-table-column>
                  <el-table-column prop="type" label="类型" width="100"></el-table-column>
                  <el-table-column prop="description" label="描述"></el-table-column>
                </el-table>
              </div>
            </el-col>
          </el-row>
          <div v-if="previewData.dependencies && previewData.dependencies.length > 0" class="preview-section">
            <h3>依赖项</h3>
            <div>
              <el-tag
                  v-for="(dep, index) in previewData.dependencies"
                  :key="index"
                  size="small"
                  style="margin-right: 5px;">
                {{ dep }}
              </el-tag>
            </div>
          </div>
        </div>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="previewVisible = false">关闭</el-button>
        <el-button type="primary" @click="handleUseComponent">使用组件</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { getAlgorithmComponents, saveAlgorithmComponent, deleteAlgorithmComponent } from '@/api/algorithm'

export default {
  name: 'AlgorithmComponents',
  data() {
    return {
      // 搜索和分页
      searchQuery: '',
      currentPage: 1,
      pageSize: 10,
      totalComponents: 0,

      // 视图控制
      isCardView: true,
      loading: false,

      // 分类相关
      categories: [
        { id: 'default', name: '默认分类' },
        { id: 'ml', name: '机器学习' },
        { id: 'dl', name: '深度学习' },
        { id: 'stats', name: '统计分析' },
        { id: 'preprocess', name: '数据预处理' }
      ],
      activeCategory: 'all',
      categoryDialogVisible: false,
      newCategoryName: '',

      // 组件数据
      components: [],

      // 对话框控制
      dialogVisible: false,
      dialogTitle: '新增算法组件',
      isEdit: false,
      activeTab: 'basic',

      // 组件表单
      componentForm: {
        id: '',
        name: '',
        category: '',
        version: '1.0.0',
        description: '',
        inputs: [],
        outputs: [],
        icon: '',
        dependencies: [],
        timeout: 30,
        enabled: true,
        createTime: new Date().toLocaleString()
      },

      // 表单验证规则
      formRules: {
        name: [
          { required: true, message: '请输入组件名称', trigger: 'blur' }
        ],
        id: [
          { required: true, message: '请输入组件ID', trigger: 'blur' },
          { pattern: /^[a-zA-Z0-9_-]+$/, message: 'ID只能包含字母、数字、下划线和横线', trigger: 'blur' }
        ],
        category: [
          { required: true, message: '请选择组件分类', trigger: 'change' }
        ],
        version: [
          { required: true, message: '请输入版本号', trigger: 'blur' },
          { pattern: /^\d+\.\d+\.\d+$/, message: '版本号格式应为x.x.x', trigger: 'blur' }
        ]
      },

      // 参数类型选项
      paramTypes: ['string', 'number', 'boolean', 'array', 'object', 'any'],

      // 依赖项选项
      dependencyOptions: ['numpy', 'pandas', 'scikit-learn', 'tensorflow', 'pytorch'],

      // 预览相关
      previewVisible: false,
      previewTitle: '组件预览',
      previewData: {}
    }
  },
  computed: {
    filteredComponents() {
      let result = this.components

      // 按分类筛选
      if (this.activeCategory !== 'all') {
        result = result.filter(c => c.category === this.activeCategory)
      }

      // 按搜索词筛选
      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase()
        result = result.filter(c =>
            c.name.toLowerCase().includes(query) ||
            c.id.toLowerCase().includes(query) ||
            c.description.toLowerCase().includes(query)
        )
      }

      // 分页
      // eslint-disable-next-line vue/no-side-effects-in-computed-properties
      this.totalComponents = result.length
      const start = (this.currentPage - 1) * this.pageSize
      const end = start + this.pageSize
      return result.slice(start, end)
    }
  },
  created() {
    this.fetchComponents()
  },
  methods: {
    // 获取组件列表
    async fetchComponents() {
      this.loading = true
      try {
        const response = await getAlgorithmComponents()
        this.components = response.data
        this.totalComponents = this.components.length
      } catch (error) {
        console.error('获取组件列表失败:', error)
        this.$message.error('获取组件列表失败')
      } finally {
        this.loading = false
      }
    },

    // 分类相关方法
    getCategoryCount(categoryId) {
      return this.components.filter(c => c.category === categoryId).length
    },

    getCategoryName(categoryId) {
      const category = this.categories.find(c => c.id === categoryId)
      return category ? category.name : '未知分类'
    },

    getComponentType(categoryId) {
      const colors = {
        'ml': 'success',
        'dl': 'warning',
        'stats': 'info',
        'preprocess': ''
      }
      return colors[categoryId] || ''
    },

    showCategoryDialog() {
      this.categoryDialogVisible = true
    },

    editCategory(row) {
      this.$set(row, 'editing', true)
      this.$set(row, 'oldName', row.name)
    },

    saveCategory(row) {
      if (!row.name.trim()) {
        this.$message.warning('分类名称不能为空')
        return
      }
      row.editing = false
      delete row.oldName
      this.$message.success('分类名称已更新')
    },

    cancelEditCategory(row) {
      row.name = row.oldName
      row.editing = false
      delete row.oldName
    },

    deleteCategory(index) {
      if (this.components.some(c => c.category === this.categories[index].id)) {
        this.$message.warning('该分类下有组件，不能删除')
        return
      }
      this.categories.splice(index, 1)
      this.$message.success('分类已删除')
    },

    addCategory() {
      if (!this.newCategoryName.trim()) {
        this.$message.warning('请输入分类名称')
        return
      }

      const newId = this.newCategoryName.toLowerCase().replace(/\s+/g, '-')
      if (this.categories.some(c => c.id === newId)) {
        this.$message.warning('该分类已存在')
        return
      }

      this.categories.push({
        id: newId,
        name: this.newCategoryName.trim()
      })
      this.newCategoryName = ''
      this.$message.success('分类已添加')
    },

    // 组件CRUD操作
    handleCreate() {
      this.dialogTitle = '新增算法组件'
      this.isEdit = false
      this.dialogVisible = true
      this.activeTab = 'basic'
    },

    handleEdit(component) {
      this.dialogTitle = '编辑算法组件'
      this.isEdit = true
      this.componentForm = JSON.parse(JSON.stringify(component))
      this.dialogVisible = true
      this.activeTab = 'basic'
    },

    handlePreview(component) {
      this.previewData = JSON.parse(JSON.stringify(component))
      this.previewTitle = `预览组件 - ${component.name}`
      this.previewVisible = true
    },

    handleDelete(component) {
      this.$confirm(`确定要删除组件 "${component.name}" 吗?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          await deleteAlgorithmComponent(component.id)
          this.$message.success('组件删除成功')
          this.fetchComponents()
        } catch (error) {
          console.error('删除组件失败:', error)
          this.$message.error('删除组件失败')
        }
      }).catch(() => {})
    },

    // 参数管理
    addParam(type) {
      const newParam = {
        name: '',
        type: 'any',
        description: '',
        required: type === 'input'
      }
      this.componentForm[`${type}s`].push(newParam)
    },

    removeParam(type, index) {
      this.componentForm[`${type}s`].splice(index, 1)
    },

    // 表单提交
    submitForm() {
      this.$refs.componentForm.validate(async valid => {
        if (!valid) {
          this.$message.warning('请填写完整的表单信息')
          return
        }

        try {
          const componentData = JSON.parse(JSON.stringify(this.componentForm))

          if (this.isEdit) {
            await saveAlgorithmComponent(componentData)
            this.$message.success('组件更新成功')
          } else {
            await saveAlgorithmComponent(componentData)
            this.$message.success('组件添加成功')
          }

          this.dialogVisible = false
          this.fetchComponents()
        } catch (error) {
          console.error('保存组件失败:', error)
          this.$message.error('保存组件失败')
        }
      })
    },

    resetForm() {
      this.$refs.componentForm.resetFields()
      this.componentForm = {
        id: '',
        name: '',
        category: '',
        version: '1.0.0',
        description: '',
        inputs: [],
        outputs: [],
        icon: '',
        dependencies: [],
        timeout: 30,
        enabled: true,
        createTime: new Date().toLocaleString()
      }
    },

    // 图片上传
    handleIconSuccess(res, file) {
      this.componentForm.icon = URL.createObjectURL(file.raw)
    },

    beforeIconUpload(file) {
      const isJPG = file.type === 'image/jpeg'
      const isPNG = file.type === 'image/png'
      const isLt2M = file.size / 1024 / 1024 < 2

      if (!isJPG && !isPNG) {
        this.$message.error('上传头像图片只能是 JPG/PNG 格式!')
      }
      if (!isLt2M) {
        this.$message.error('上传头像图片大小不能超过 2MB!')
      }
      return (isJPG || isPNG) && isLt2M
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

    // 预览操作
    handleUseComponent() {
      this.$message.success(`组件 ${this.previewData.name} 已添加到流程中`)
      this.previewVisible = false
    }
  }
}
</script>

<style scoped>
.algorithm-components-container {
  padding: 20px;
}

.toolbar-card {
  margin-bottom: 20px;
}

.text-right {
  text-align: right;
}

.category-tabs {
  margin-bottom: 20px;
}

.category-tag {
  margin-right: 10px;
  cursor: pointer;
}

.category-tag:hover {
  opacity: 0.8;
}

.component-cards {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

.component-card {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.component-title {
  font-weight: bold;
  font-size: 16px;
}

.component-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.component-meta {
  margin-bottom: 10px;
  font-size: 13px;
  color: #666;
}

.meta-label {
  color: #999;
  margin-right: 5px;
}

.component-desc {
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

.component-params {
  margin-bottom: 15px;
}

.component-actions {
  text-align: right;
}

.pagination-container {
  margin-top: 20px;
  text-align: center;
}

.param-actions {
  margin-bottom: 10px;
}

.component-icon {
  width: 100px;
  height: 100px;
  display: block;
}

.avatar-uploader >>> .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}

.avatar-uploader >>> .el-upload:hover {
  border-color: #409EFF;
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 100px;
  height: 100px;
  line-height: 100px;
  text-align: center;
}

.category-manage {
  padding: 10px;
}

.add-category {
  margin-top: 20px;
}

.component-preview {
  padding: 10px;
}

.preview-header {
  margin-bottom: 20px;
  padding-bottom: 10px;
  border-bottom: 1px solid #eee;
}

.preview-title {
  font-size: 20px;
  font-weight: bold;
  margin-bottom: 5px;
}

.preview-meta {
  display: flex;
  align-items: center;
}

.preview-version {
  margin-left: 10px;
  color: #666;
}

.preview-section {
  margin-bottom: 20px;
}

.preview-section h3 {
  margin-bottom: 10px;
  color: #333;
}

.preview-description {
  margin-bottom: 20px;
  padding-bottom: 10px;
  border-bottom: 1px solid #eee;
}

.preview-description h3 {
  margin-bottom: 10px;
}

.component-name {
  font-weight: bold;
}
</style>
