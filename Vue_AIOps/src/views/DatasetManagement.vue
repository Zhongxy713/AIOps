<template>
  <div class="dataset-management-container">
    <!-- 顶部操作栏 -->
    <el-card shadow="never" class="toolbar-card">
      <el-row :gutter="20">
        <el-col :span="6">
          <el-input
              v-model="searchQuery"
              placeholder="搜索数据集名称/描述"
              clearable
              prefix-icon="el-icon-search"
              @clear="handleSearch"
              @keyup.enter.native="handleSearch">
          </el-input>
        </el-col>
        <el-col :span="18" class="text-right">
          <el-button type="primary" icon="el-icon-plus" @click="showUploadDialog">上传数据集</el-button>
          <el-button icon="el-icon-refresh" @click="fetchDatasets">刷新</el-button>
          <el-button-group style="margin-left: 10px;">
            <el-button :icon="viewType === 'card' ? 'el-icon-menu' : 'el-icon-s-grid'"
                       @click="viewType = 'card'">卡片</el-button>
            <el-button :icon="viewType === 'list' ? 'el-icon-menu' : 'el-icon-s-grid'"
                       @click="viewType = 'list'">列表</el-button>
          </el-button-group>
        </el-col>
      </el-row>
    </el-card>

    <!-- 数据类型筛选 -->
    <div class="filter-tabs">
      <el-radio-group v-model="activeDataType" @change="handleDataTypeChange">
        <el-radio-button label="all">全部</el-radio-button>
        <el-radio-button label="image">图片</el-radio-button>
        <el-radio-button label="video">视频</el-radio-button>
        <el-radio-button label="text">文本</el-radio-button>
        <el-radio-button label="table">表格</el-radio-button>
        <el-radio-button label="audio">音频</el-radio-button>
        <el-radio-button label="custom">自定义</el-radio-button>
      </el-radio-group>
    </div>

    <!-- 卡片视图 -->
    <div v-if="viewType === 'card' && filteredDatasets.length > 0" class="dataset-cards">
      <el-card
          v-for="dataset in filteredDatasets"
          :key="dataset.id"
          shadow="hover"
          class="dataset-card">
        <div slot="header" class="card-header">
          <div class="dataset-title">
            <span>{{ dataset.name }}</span>
            <el-tag size="mini" :type="getDataTypeTagType(dataset.dataType)">
              {{ getDataTypeName(dataset.dataType) }}
            </el-tag>
          </div>
          <div class="card-actions">
            <el-button
                size="mini"
                icon="el-icon-download"
                circle
                @click.stop="downloadDataset(dataset)">
            </el-button>
          </div>
        </div>
        <div class="dataset-content">
          <div class="dataset-preview" @click="previewDataset(dataset)">
            <!-- 图片预览 -->
            <img v-if="dataset.dataType === 'image' && dataset.previewUrl"
                 :src="dataset.previewUrl"
                 class="preview-image">
            <!-- 视频预览 -->
            <video v-else-if="dataset.dataType === 'video' && dataset.previewUrl"
                   class="preview-video"
                   :poster="dataset.thumbnailUrl">
              <source :src="dataset.previewUrl" type="video/mp4">
            </video>
            <!-- 音频预览 -->
            <audio v-else-if="dataset.dataType === 'audio' && dataset.previewUrl"
                   class="preview-audio"
                   controls>
              <source :src="dataset.previewUrl" type="audio/mpeg">
            </audio>
            <!-- 其他类型预览 -->
            <div v-else class="preview-default">
              <i :class="getDataTypeIcon(dataset.dataType)"></i>
              <span>{{ getDataTypeName(dataset.dataType) }}数据集</span>
            </div>
          </div>
          <div class="dataset-meta">
            <div><span class="meta-label">文件数:</span> {{ dataset.fileCount }}</div>
            <div><span class="meta-label">大小:</span> {{ formatFileSize(dataset.size) }}</div>
            <div><span class="meta-label">创建时间:</span> {{ formatTime(dataset.createTime) }}</div>
            <div><span class="meta-label">创建者:</span> {{ dataset.creator }}</div>
          </div>
          <div class="dataset-desc">{{ dataset.description || '暂无描述' }}</div>
          <div class="dataset-tags">
            <el-tag
                v-for="(tag, index) in dataset.tags.slice(0, 3)"
                :key="index"
                size="mini"
                type="info">
              {{ tag }}
            </el-tag>
            <el-tag size="mini" v-if="dataset.tags.length > 3">+{{ dataset.tags.length - 3 }}</el-tag>
          </div>
        </div>
        <div class="dataset-footer">
          <el-button-group>
            <el-tooltip content="查看详情" placement="top">
              <el-button
                  size="mini"
                  icon="el-icon-view"
                  @click.stop="showDetail(dataset)">
              </el-button>
            </el-tooltip>
            <el-tooltip content="使用数据集" placement="top">
              <el-button
                  size="mini"
                  icon="el-icon-connection"
                  @click.stop="useDataset(dataset)">
              </el-button>
            </el-tooltip>
            <el-tooltip content="删除数据集" placement="top">
              <el-button
                  size="mini"
                  icon="el-icon-delete"
                  type="danger"
                  @click.stop="handleDelete(dataset)">
              </el-button>
            </el-tooltip>
          </el-button-group>
        </div>
      </el-card>
    </div>

    <!-- 列表视图 -->
    <el-table
        v-else-if="viewType === 'list' && filteredDatasets.length > 0"
        :data="filteredDatasets"
        style="width: 100%"
        border
        v-loading="loading"
        class="dataset-table">
      <el-table-column prop="name" label="数据集名称" width="180">
        <template slot-scope="{row}">
          <span class="dataset-name">{{ row.name }}</span>
          <el-tag size="mini" :type="getDataTypeTagType(row.dataType)" style="margin-left: 5px;">
            {{ getDataTypeName(row.dataType) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="预览" width="120">
        <template slot-scope="{row}">
          <img v-if="row.dataType === 'image' && row.thumbnailUrl"
               :src="row.thumbnailUrl"
               class="table-thumbnail">
          <i v-else :class="getDataTypeIcon(row.dataType)" class="table-icon"></i>
        </template>
      </el-table-column>
      <el-table-column prop="fileCount" label="文件数" width="100"></el-table-column>
      <el-table-column prop="size" label="大小" width="120">
        <template slot-scope="{row}">
          {{ formatFileSize(row.size) }}
        </template>
      </el-table-column>
      <el-table-column prop="creator" label="创建者" width="120"></el-table-column>
      <el-table-column prop="createTime" label="创建时间" width="180">
        <template slot-scope="{row}">
          {{ formatTime(row.createTime) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180" fixed="right">
        <template slot-scope="{row}">
          <el-button size="mini" icon="el-icon-view" @click="showDetail(row)">详情</el-button>
          <el-dropdown size="mini" trigger="click" @command="handleMoreAction(row, $command)">
            <el-button size="mini">
              更多<i class="el-icon-arrow-down el-icon--right"></i>
            </el-button>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="download"><i class="el-icon-download"></i>下载</el-dropdown-item>
              <el-dropdown-item command="use"><i class="el-icon-connection"></i>使用</el-dropdown-item>
              <el-dropdown-item command="delete" divided style="color: #F56C6C;">
                <i class="el-icon-delete"></i>删除
              </el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </template>
      </el-table-column>
    </el-table>

    <!-- 空状态 -->
    <el-empty v-else description="暂无数据集" style="margin-top: 50px;"></el-empty>

    <!-- 分页 -->
    <div class="pagination-container" v-if="filteredDatasets.length > 0">
      <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="currentPage"
          :page-sizes="[10, 20, 30, 50]"
          :page-size="pageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="totalDatasets">
      </el-pagination>
    </div>

    <!-- 上传数据集对话框 -->
    <el-dialog
        title="上传数据集"
        :visible.sync="uploadDialogVisible"
        width="60%"
        @closed="resetUploadForm">
      <el-form
          :model="uploadForm"
          :rules="uploadRules"
          ref="uploadForm"
          label-width="120px"
          label-position="right">
        <el-tabs v-model="uploadActiveTab">
          <el-tab-pane label="基本信息" name="basic">
            <el-form-item label="数据集名称" prop="name">
              <el-input v-model="uploadForm.name" placeholder="请输入数据集名称"></el-input>
            </el-form-item>
            <el-form-item label="数据类型" prop="dataType">
              <el-select v-model="uploadForm.dataType" placeholder="请选择数据类型">
                <el-option
                    v-for="type in dataTypes"
                    :key="type.value"
                    :label="type.label"
                    :value="type.value">
                </el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="数据集描述">
              <el-input
                  type="textarea"
                  :rows="3"
                  v-model="uploadForm.description"
                  placeholder="请输入数据集描述">
              </el-input>
            </el-form-item>
            <el-form-item label="数据集标签">
              <el-tag
                  v-for="tag in uploadForm.tags"
                  :key="tag"
                  closable
                  @close="removeUploadTag(tag)">
                {{ tag }}
              </el-tag>
              <el-input
                  class="input-new-tag"
                  v-if="uploadTagInputVisible"
                  v-model="uploadTagInputValue"
                  ref="saveUploadTagInput"
                  size="small"
                  @keyup.enter.native="handleUploadTagInputConfirm"
                  @blur="handleUploadTagInputConfirm">
              </el-input>
              <el-button v-else class="button-new-tag" size="small" @click="showUploadTagInput">+ 添加标签</el-button>
            </el-form-item>
          </el-tab-pane>

          <el-tab-pane label="上传文件" name="upload">
            <el-form-item label="上传方式">
              <el-radio-group v-model="uploadForm.uploadMethod">
                <el-radio label="file">文件上传</el-radio>
                <el-radio label="folder">文件夹上传</el-radio>
                <el-radio label="url">URL导入</el-radio>
              </el-radio-group>
            </el-form-item>

            <!-- 文件上传 -->
            <div v-if="uploadForm.uploadMethod === 'file'">
              <el-upload
                  class="upload-demo"
                  drag
                  multiple
                  :action="uploadUrl"
                  :file-list="uploadForm.files"
                  :before-upload="beforeFileUpload"
                  :on-success="handleFileSuccess"
                  :on-error="handleFileError"
                  :on-remove="handleFileRemove">
                <i class="el-icon-upload"></i>
                <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
                <div class="el-upload__tip" slot="tip">
                  支持 {{ getUploadFileTypes() }} 格式文件，单个文件不超过 {{ maxFileSize }}MB
                </div>
              </el-upload>
            </div>

            <!-- 文件夹上传 -->
            <div v-else-if="uploadForm.uploadMethod === 'folder'">
              <el-upload
                  class="upload-demo"
                  drag
                  :action="uploadUrl"
                  :file-list="uploadForm.files"
                  :before-upload="beforeFileUpload"
                  :on-success="handleFileSuccess"
                  :on-error="handleFileError"
                  :on-remove="handleFileRemove"
                  webkitdirectory>
                <i class="el-icon-upload"></i>
                <div class="el-upload__text">将文件夹拖到此处，或<em>点击上传</em></div>
                <div class="el-upload__tip" slot="tip">
                  支持 {{ getUploadFileTypes() }} 格式文件，单个文件不超过 {{ maxFileSize }}MB
                </div>
              </el-upload>
            </div>

            <!-- URL导入 -->
            <div v-else-if="uploadForm.uploadMethod === 'url'">
              <el-form-item label="URL列表">
                <el-input
                    type="textarea"
                    :rows="5"
                    v-model="uploadForm.urlList"
                    placeholder="每行输入一个文件URL，支持HTTP/HTTPS/FTP协议">
                </el-input>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="importFromUrls">开始导入</el-button>
                <el-button @click="uploadForm.urlList = ''">清空</el-button>
              </el-form-item>
            </div>
          </el-tab-pane>

          <el-tab-pane label="高级设置" name="advanced">
            <el-form-item label="文件命名规则">
              <el-select v-model="uploadForm.namingRule" placeholder="请选择命名规则">
                <el-option label="保留原文件名" value="original"></el-option>
                <el-option label="自动编号" value="auto"></el-option>
                <el-option label="自定义前缀+编号" value="custom"></el-option>
              </el-select>
              <el-input
                  v-if="uploadForm.namingRule === 'custom'"
                  v-model="uploadForm.customPrefix"
                  placeholder="输入前缀"
                  style="width: 200px; margin-left: 10px;">
              </el-input>
            </el-form-item>
            <el-form-item label="文件校验">
              <el-checkbox v-model="uploadForm.checkDuplicate">检查重复文件</el-checkbox>
              <el-checkbox v-model="uploadForm.checkIntegrity">检查文件完整性</el-checkbox>
            </el-form-item>
            <el-form-item label="自动解压">
              <el-checkbox v-model="uploadForm.autoUnzip">自动解压ZIP/RAR文件</el-checkbox>
            </el-form-item>
            <el-form-item label="存储位置">
              <el-select v-model="uploadForm.storageLocation" placeholder="请选择存储位置">
                <el-option label="默认存储" value="default"></el-option>
                <el-option label="高性能存储" value="high_perf"></el-option>
                <el-option label="归档存储" value="archive"></el-option>
              </el-select>
            </el-form-item>
          </el-tab-pane>
        </el-tabs>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="uploadDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitUpload" :loading="uploading">开始上传</el-button>
      </span>
    </el-dialog>

    <!-- 数据集详情对话框 -->
    <el-dialog
        :title="`数据集详情 - ${currentDataset ? currentDataset.name : ''}`"
        :visible.sync="detailDialogVisible"
        width="70%"
        top="5vh">
      <div v-if="currentDataset" class="dataset-detail">
        <el-row :gutter="20">
          <el-col :span="8">
            <el-card shadow="never" class="detail-card">
              <div slot="header" class="detail-header">
                <span>基本信息</span>
              </div>
              <div class="detail-content">
                <div class="detail-item">
                  <span class="detail-label">数据集ID:</span>
                  <span class="detail-value">{{ currentDataset.id }}</span>
                </div>
                <div class="detail-item">
                  <span class="detail-label">数据类型:</span>
                  <span class="detail-value">
                    <el-tag :type="getDataTypeTagType(currentDataset.dataType)" size="small">
                      {{ getDataTypeName(currentDataset.dataType) }}
                    </el-tag>
                  </span>
                </div>
                <div class="detail-item">
                  <span class="detail-label">文件数量:</span>
                  <span class="detail-value">{{ currentDataset.fileCount }}</span>
                </div>
                <div class="detail-item">
                  <span class="detail-label">总大小:</span>
                  <span class="detail-value">{{ formatFileSize(currentDataset.size) }}</span>
                </div>
                <div class="detail-item">
                  <span class="detail-label">创建时间:</span>
                  <span class="detail-value">{{ formatTime(currentDataset.createTime) }}</span>
                </div>
                <div class="detail-item">
                  <span class="detail-label">创建者:</span>
                  <span class="detail-value">{{ currentDataset.creator }}</span>
                </div>
                <div class="detail-item">
                  <span class="detail-label">标签:</span>
                  <span class="detail-value">
                    <el-tag
                        v-for="(tag, index) in currentDataset.tags"
                        :key="index"
                        size="small"
                        style="margin-right: 5px;">
                      {{ tag }}
                    </el-tag>
                  </span>
                </div>
              </div>
            </el-card>
          </el-col>
          <el-col :span="16">
            <el-card shadow="never" class="detail-card">
              <div slot="header" class="detail-header">
                <span>文件列表</span>
                <el-button size="mini" @click="refreshFileList">刷新</el-button>
              </div>
              <div class="file-list-container">
                <el-table
                    :data="fileList"
                    border
                    size="small"
                    height="400">
                  <el-table-column prop="name" label="文件名" width="200">
                    <template slot-scope="{row}">
                      <div class="file-name">
                        <i :class="getFileIcon(row.name)"></i>
                        <span>{{ row.name }}</span>
                      </div>
                    </template>
                  </el-table-column>
                  <el-table-column prop="size" label="大小" width="120">
                    <template slot-scope="{row}">
                      {{ formatFileSize(row.size) }}
                    </template>
                  </el-table-column>
                  <el-table-column prop="type" label="类型" width="120">
                    <template slot-scope="{row}">
                      {{ getFileType(row.name) }}
                    </template>
                  </el-table-column>
                  <el-table-column prop="modifiedTime" label="修改时间" width="180">
                    <template slot-scope="{row}">
                      {{ formatTime(row.modifiedTime) }}
                    </template>
                  </el-table-column>
                  <el-table-column label="操作" width="120">
                    <template slot-scope="{row}">
                      <el-button size="mini" @click="previewFile(row)">预览</el-button>
                      <el-button size="mini" @click="downloadFile(row)">下载</el-button>
                    </template>
                  </el-table-column>
                </el-table>
              </div>
            </el-card>
          </el-col>
        </el-row>
        <el-card shadow="never" class="detail-card" style="margin-top: 20px;">
          <div slot="header" class="detail-header">
            <span>数据集描述</span>
          </div>
          <div class="dataset-description">
            {{ currentDataset.description || '暂无描述' }}
          </div>
        </el-card>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="detailDialogVisible = false">关闭</el-button>
        <el-button type="primary" @click="useDataset(currentDataset)">使用数据集</el-button>
      </span>
    </el-dialog>

    <!-- 文件预览对话框 -->
    <el-dialog
        :title="`文件预览 - ${currentFile ? currentFile.name : ''}`"
        :visible.sync="previewDialogVisible"
        width="80%"
        top="5vh">
      <div v-if="currentFile" class="file-preview-container">
        <!-- 图片预览 -->
        <img v-if="isImageFile(currentFile.name)"
             :src="currentFile.previewUrl"
             style="max-width: 100%; max-height: 70vh; display: block; margin: 0 auto;">

        <!-- 视频预览 -->
        <video v-else-if="isVideoFile(currentFile.name)"
               controls
               style="max-width: 100%; max-height: 70vh; display: block; margin: 0 auto;">
          <source :src="currentFile.previewUrl" :type="getVideoMimeType(currentFile.name)">
        </video>

        <!-- 音频预览 -->
        <audio v-else-if="isAudioFile(currentFile.name)"
               controls
               style="width: 100%; margin: 20px 0;">
          <source :src="currentFile.previewUrl" :type="getAudioMimeType(currentFile.name)">
        </audio>

        <!-- 文本预览 -->
        <div v-else-if="isTextFile(currentFile.name)" class="text-preview">
          <pre>{{ currentFile.content }}</pre>
        </div>

        <!-- 不支持预览 -->
        <div v-else class="unsupported-preview">
          <i class="el-icon-document"></i>
          <p>不支持预览此类型文件</p>
        </div>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="previewDialogVisible = false">关闭</el-button>
        <el-button type="primary" @click="downloadFile(currentFile)">下载</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { getDatasets, uploadDataset, deleteDataset, getDatasetFiles } from '@/api/dataset'

export default {
  name: 'DatasetManagement',
  data() {
    return {
      // 搜索和分页
      searchQuery: '',
      currentPage: 1,
      pageSize: 10,
      totalDatasets: 0,

      // 视图控制
      viewType: 'card',
      loading: false,

      // 筛选条件
      activeDataType: 'all',
      dataTypes: [
        { label: '图片', value: 'image' },
        { label: '视频', value: 'video' },
        { label: '文本', value: 'text' },
        { label: '表格', value: 'table' },
        { label: '音频', value: 'audio' },
        { label: '自定义', value: 'custom' }
      ],

      // 数据集数据
      datasets: [],
      currentDataset: null,
      fileList: [],
      currentFile: null,

      // 对话框控制
      uploadDialogVisible: false,
      detailDialogVisible: false,
      previewDialogVisible: false,
      uploadActiveTab: 'basic',
      uploading: false,

      // 上传表单
      uploadForm: {
        name: '',
        dataType: 'image',
        description: '',
        tags: [],
        uploadMethod: 'file',
        files: [],
        urlList: '',
        namingRule: 'original',
        customPrefix: '',
        checkDuplicate: true,
        checkIntegrity: true,
        autoUnzip: true,
        storageLocation: 'default'
      },

      // 上传规则
      uploadRules: {
        name: [
          { required: true, message: '请输入数据集名称', trigger: 'blur' }
        ],
        dataType: [
          { required: true, message: '请选择数据类型', trigger: 'change' }
        ]
      },

      // 上传配置
      uploadUrl: '/api/dataset/upload',
      maxFileSize: 100, // MB

      // 标签输入
      uploadTagInputVisible: false,
      uploadTagInputValue: '',

      // 文件类型图标映射
      fileIcons: {
        image: 'el-icon-picture',
        video: 'el-icon-video-camera',
        audio: 'el-icon-microphone',
        text: 'el-icon-document',
        table: 'el-icon-s-grid',
        archive: 'el-icon-files',
        code: 'el-icon-document',
        pdf: 'el-icon-document',
        word: 'el-icon-document',
        excel: 'el-icon-s-grid',
        ppt: 'el-icon-document',
        other: 'el-icon-document'
      }
    }
  },
  computed: {
    filteredDatasets() {
      let result = this.datasets

      // 按数据类型筛选
      if (this.activeDataType !== 'all') {
        result = result.filter(d => d.dataType === this.activeDataType)
      }

      // 按搜索词筛选
      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase()
        result = result.filter(d =>
            d.name.toLowerCase().includes(query) ||
            (d.description && d.description.toLowerCase().includes(query)) ||
            (d.tags && d.tags.some(tag => tag.toLowerCase().includes(query)))
        )
      }

      // 分页
      // eslint-disable-next-line vue/no-side-effects-in-computed-properties
      this.totalDatasets = result.length
      const start = (this.currentPage - 1) * this.pageSize
      const end = start + this.pageSize
      return result.slice(start, end)
    }
  },
  created() {
    this.fetchDatasets()
  },
  methods: {
    // 获取数据集列表
    async fetchDatasets() {
      this.loading = true
      try {
        const response = await getDatasets()
        this.datasets = response.data.map(dataset => ({
          ...dataset,
          previewUrl: this.generatePreviewUrl(dataset),
          thumbnailUrl: this.generateThumbnailUrl(dataset)
        }))
        this.totalDatasets = this.datasets.length
      } catch (error) {
        console.error('获取数据集列表失败:', error)
        this.$message.error('获取数据集列表失败')
      } finally {
        this.loading = false
      }
    },

    // 生成预览URL
    generatePreviewUrl(dataset) {
      if (dataset.dataType === 'image') {
        return `https://example.com/preview/${dataset.id}/sample.jpg`
      } else if (dataset.dataType === 'video') {
        return `https://example.com/preview/${dataset.id}/sample.mp4`
      } else if (dataset.dataType === 'audio') {
        return `https://example.com/preview/${dataset.id}/sample.mp3`
      }
      return null
    },

    // 生成缩略图URL
    generateThumbnailUrl(dataset) {
      if (dataset.dataType === 'image') {
        return `https://example.com/thumbnail/${dataset.id}/sample.jpg`
      } else if (dataset.dataType === 'video') {
        return `https://example.com/thumbnail/${dataset.id}/sample.jpg`
      }
      return null
    },

    // 获取数据类型名称
    getDataTypeName(type) {
      const typeMap = {
        image: '图片',
        video: '视频',
        text: '文本',
        table: '表格',
        audio: '音频',
        custom: '自定义'
      }
      return typeMap[type] || '未知'
    },

    // 获取数据类型标签样式
    getDataTypeTagType(type) {
      const typeMap = {
        image: 'success',
        video: 'warning',
        text: '',
        table: 'info',
        audio: 'primary',
        custom: 'danger'
      }
      return typeMap[type] || ''
    },

    // 获取数据类型图标
    getDataTypeIcon(type) {
      const iconMap = {
        image: 'el-icon-picture',
        video: 'el-icon-video-camera',
        text: 'el-icon-document',
        table: 'el-icon-s-grid',
        audio: 'el-icon-microphone',
        custom: 'el-icon-files'
      }
      return iconMap[type] || 'el-icon-document'
    },

    // 显示上传对话框
    showUploadDialog() {
      this.uploadDialogVisible = true
      this.uploadActiveTab = 'basic'
    },

    // 重置上传表单
    resetUploadForm() {
      this.$refs.uploadForm.resetFields()
      this.uploadForm = {
        name: '',
        dataType: 'image',
        description: '',
        tags: [],
        uploadMethod: 'file',
        files: [],
        urlList: '',
        namingRule: 'original',
        customPrefix: '',
        checkDuplicate: true,
        checkIntegrity: true,
        autoUnzip: true,
        storageLocation: 'default'
      }
    },

    // 获取支持上传的文件类型
    getUploadFileTypes() {
      const typeMap = {
        image: 'JPG/PNG/GIF/BMP',
        video: 'MP4/AVI/MOV',
        text: 'TXT/CSV/JSON/XML',
        table: 'CSV/XLS/XLSX',
        audio: 'MP3/WAV',
        custom: '任意类型'
      }
      return typeMap[this.uploadForm.dataType] || '任意类型'
    },

    // 文件上传前校验
    beforeFileUpload(file) {
      const isLtMaxSize = file.size / 1024 / 1024 < this.maxFileSize
      if (!isLtMaxSize) {
        this.$message.error(`文件大小不能超过 ${this.maxFileSize}MB!`)
        return false
      }

      // 根据数据类型检查文件格式
      const fileType = file.name.split('.').pop().toLowerCase()
      const allowedTypes = this.getAllowedFileTypes()

      if (allowedTypes.length > 0 && !allowedTypes.includes(fileType)) {
        this.$message.error(`不支持上传 ${fileType} 格式文件!`)
        return false
      }

      return true
    },

    // 获取允许上传的文件类型
    getAllowedFileTypes() {
      const typeMap = {
        image: ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
        video: ['mp4', 'avi', 'mov', 'mkv'],
        text: ['txt', 'csv', 'json', 'xml'],
        table: ['csv', 'xls', 'xlsx'],
        audio: ['mp3', 'wav'],
        custom: []
      }
      return typeMap[this.uploadForm.dataType] || []
    },

    // 文件上传成功
    handleFileSuccess(response, file, fileList) {
      this.uploadForm.files = fileList
      this.$message.success(`${file.name} 上传成功`)
    },

    // 文件上传失败
    handleFileError(err, file) {
      this.$message.error(`${file.name} 上传失败: ${err.message}`)
    },

    // 移除文件
    handleFileRemove(file, fileList) {
      this.uploadForm.files = fileList
    },

    // 从URL导入
    importFromUrls() {
      if (!this.uploadForm.urlList.trim()) {
        this.$message.warning('请输入至少一个URL')
        return
      }

      const urls = this.uploadForm.urlList.split('\n').filter(url => url.trim())
      this.$message.success(`开始导入 ${urls.length} 个文件`)
      // 实际项目中这里应该调用API导入URL
    },

    // 提交上传
    submitUpload()
    {
      this.$refs.uploadForm.validate(async valid => {
        if (!valid) {
          this.$message.warning('请填写完整的信息')
          return
        }

        if (this.uploadForm.uploadMethod !== 'url' && this.uploadForm.files.length === 0) {
          this.$message.warning('请上传至少一个文件')
          return
        }

        this.uploading = true
        try {
          const formData = new FormData()
          formData.append('name', this.uploadForm.name)
          formData.append('dataType', this.uploadForm.dataType)
          formData.append('description', this.uploadForm.description)
          formData.append('tags', this.uploadForm.tags.join(','))

          if (this.uploadForm.uploadMethod === 'url') {
            formData.append('urlList', this.uploadForm.urlList)
          } else {
            this.uploadForm.files.forEach(file => {
              formData.append('files', file.raw)
            })
          }

          await uploadDataset(formData);
          this.$message.success('数据集上传成功')
          this.uploadDialogVisible = false
          this.fetchDatasets()
        } catch (error) {
          console.error('上传数据集失败:', error)
          this.$message.error('上传数据集失败')
        } finally {
          this.uploading = false
        }
      })
    }
,

    // 标签管理
    showUploadTagInput() {
      this.uploadTagInputVisible = true
      this.$nextTick(() => {
        this.$refs.saveUploadTagInput.$refs.input.focus()
      })
    },

    handleUploadTagInputConfirm() {
      const inputValue = this.uploadTagInputValue.trim()
      if (inputValue && !this.uploadForm.tags.includes(inputValue)) {
        this.uploadForm.tags.push(inputValue)
      }
      this.uploadTagInputVisible = false
      this.uploadTagInputValue = ''
    },

    removeUploadTag(tag) {
      this.uploadForm.tags = this.uploadForm.tags.filter(t => t !== tag)
    },

    // 显示数据集详情
    async showDetail(dataset) {
      this.currentDataset = dataset
      this.detailDialogVisible = true
      await this.fetchFileList(dataset.id)
    },

    // 获取文件列表
    async fetchFileList(datasetId) {
      try {
        const response = await getDatasetFiles(datasetId)
        this.fileList = response.data
      } catch (error) {
        console.error('获取文件列表失败:', error)
        this.$message.error('获取文件列表失败')
      }
    },

    // 刷新文件列表
    refreshFileList() {
      if (this.currentDataset) {
        this.fetchFileList(this.currentDataset.id)
      }
    },

    // 预览数据集
    previewDataset(dataset) {
      this.currentDataset = dataset
      this.previewDialogVisible = true
    },

    // 预览文件
    previewFile(file) {
      this.currentFile = file
      this.previewDialogVisible = true
    },

    // 下载数据集
    downloadDataset(dataset) {
      this.$message.success(`开始下载数据集 ${dataset.name}`)
      // 实际项目中这里应该调用下载API
    },

    // 下载文件
    downloadFile(file) {
      if (!file) return
      this.$message.success(`开始下载文件 ${file.name}`)
      // 实际项目中这里应该调用下载API
    },

    // 使用数据集
    useDataset(dataset) {
      this.$message.success(`已选择数据集 ${dataset.name}`)
      this.detailDialogVisible = false
      // 实际项目中这里应该触发使用数据集的事件
    },

    // 删除数据集
    handleDelete(dataset) {
      this.$confirm(`确定要删除数据集 "${dataset.name}" 吗?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        try {
          await deleteDataset(dataset.id)
          this.$message.success('数据集删除成功')
          this.fetchDatasets()
        } catch (error) {
          console.error('删除数据集失败:', error)
          this.$message.error('删除数据集失败')
        }
      }).catch(() => {})
    },

    // 处理更多操作
    handleMoreAction(row, command) {
      switch (command) {
        case 'download':
          this.downloadDataset(row)
          break
        case 'use':
          this.useDataset(row)
          break
        case 'delete':
          this.handleDelete(row)
          break
      }
    },

    // 文件类型判断
    isImageFile(filename) {
      const ext = filename.split('.').pop().toLowerCase()
      return ['jpg', 'jpeg', 'png', 'gif', 'bmp'].includes(ext)
    },

    isVideoFile(filename) {
      const ext = filename.split('.').pop().toLowerCase()
      return ['mp4', 'avi', 'mov', 'mkv'].includes(ext)
    },

    isAudioFile(filename) {
      const ext = filename.split('.').pop().toLowerCase()
      return ['mp3', 'wav'].includes(ext)
    },

    isTextFile(filename) {
      const ext = filename.split('.').pop().toLowerCase()
      return ['txt', 'csv', 'json', 'xml'].includes(ext)
    },

    // 获取文件图标
    getFileIcon(filename) {
      if (!filename) return this.fileIcons.other

      const ext = filename.split('.').pop().toLowerCase()

      if (this.isImageFile(filename)) return this.fileIcons.image
      if (this.isVideoFile(filename)) return this.fileIcons.video
      if (this.isAudioFile(filename)) return this.fileIcons.audio
      if (['txt', 'md'].includes(ext)) return this.fileIcons.text
      if (['csv', 'xls', 'xlsx'].includes(ext)) return this.fileIcons.table
      if (['zip', 'rar', '7z'].includes(ext)) return this.fileIcons.archive
      if (['pdf'].includes(ext)) return this.fileIcons.pdf
      if (['doc', 'docx'].includes(ext)) return this.fileIcons.word
      if (['ppt', 'pptx'].includes(ext)) return this.fileIcons.ppt
      if (['py', 'js', 'java', 'cpp', 'html', 'css'].includes(ext)) return this.fileIcons.code

      return this.fileIcons.other
    },

    // 获取文件类型
    getFileType(filename) {
      if (!filename) return '未知'

      const ext = filename.split('.').pop().toLowerCase()

      if (this.isImageFile(filename)) return '图片'
      if (this.isVideoFile(filename)) return '视频'
      if (this.isAudioFile(filename)) return '音频'
      if (['txt', 'md'].includes(ext)) return '文本'
      if (['csv', 'xls', 'xlsx'].includes(ext)) return '表格'
      if (['zip', 'rar', '7z'].includes(ext)) return '压缩包'
      if (['pdf'].includes(ext)) return 'PDF'
      if (['doc', 'docx'].includes(ext)) return 'Word'
      if (['ppt', 'pptx'].includes(ext)) return 'PPT'
      if (['py', 'js', 'java', 'cpp', 'html', 'css'].includes(ext)) return '代码'

      return ext.toUpperCase() + '文件'
    },

    // 获取视频MIME类型
    getVideoMimeType(filename) {
      const ext = filename.split('.').pop().toLowerCase()
      const typeMap = {
        mp4: 'video/mp4',
        avi: 'video/x-msvideo',
        mov: 'video/quicktime',
        mkv: 'video/x-matroska'
      }
      return typeMap[ext] || 'video/mp4'
    },

    // 获取音频MIME类型
    getAudioMimeType(filename) {
      const ext = filename.split('.').pop().toLowerCase()
      const typeMap = {
        mp3: 'audio/mpeg',
        wav: 'audio/wav'
      }
      return typeMap[ext] || 'audio/mpeg'
    },

    // 格式化文件大小
    formatFileSize(bytes) {
      if (bytes === 0) return '0 B'
      const k = 1024
      const sizes = ['B', 'KB', 'MB', 'GB', 'TB']
      const i = Math.floor(Math.log(bytes) / Math.log(k))
      return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
    },

    // 格式化时间
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
    handleDataTypeChange() {
      this.currentPage = 1
    }
  }
}
</script>

<style scoped>
.dataset-management-container {
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
}

.dataset-cards {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  margin-bottom: 20px;
}

.dataset-card {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.dataset-title {
  display: flex;
  align-items: center;
}

.card-actions {
  margin-left: 10px;
}

.dataset-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.dataset-preview {
  height: 180px;
  margin-bottom: 15px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f5f7fa;
  border-radius: 4px;
  overflow: hidden;
}

.preview-image {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

.preview-video {
  max-width: 100%;
  max-height: 100%;
}

.preview-audio {
  width: 100%;
}

.preview-default {
  text-align: center;
  color: #909399;
}

.preview-default i {
  font-size: 40px;
  display: block;
  margin-bottom: 10px;
}

.dataset-meta {
  margin-bottom: 10px;
  font-size: 13px;
  color: #666;
}

.meta-label {
  color: #999;
  margin-right: 5px;
}

.dataset-desc {
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

.dataset-tags {
  margin-bottom: 15px;
}

.dataset-footer {
  text-align: right;
}

.pagination-container {
  margin-top: 20px;
  text-align: center;
}

.upload-demo {
  text-align: center;
}

.dataset-detail {
  padding: 10px;
}

.detail-card {
  margin-bottom: 0;
}

.detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.detail-content {
  padding: 10px;
}

.detail-item {
  margin-bottom: 10px;
  display: flex;
}

.detail-label {
  width: 80px;
  color: #909399;
}

.detail-value {
  flex: 1;
}

.file-list-container {
  margin-top: 10px;
}

.file-name {
  display: flex;
  align-items: center;
}

.file-name i {
  margin-right: 5px;
  font-size: 16px;
}

.dataset-table {
  margin-bottom: 20px;
}

.dataset-name {
  font-weight: bold;
}

.table-thumbnail {
  width: 60px;
  height: 40px;
  object-fit: cover;
  border-radius: 2px;
}

.table-icon {
  font-size: 24px;
  color: #909399;
}

.text-preview {
  max-height: 70vh;
  overflow: auto;
  background: #f5f7fa;
  padding: 15px;
  border-radius: 4px;
  font-family: monospace;
  white-space: pre-wrap;
}

.unsupported-preview {
  text-align: center;
  padding: 40px 0;
  color: #909399;
}

.unsupported-preview i {
  font-size: 60px;
  margin-bottom: 20px;
}

.dataset-description {
  padding: 15px;
  line-height: 1.6;
}
</style>
