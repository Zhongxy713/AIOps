// 模拟获取数据集列表
export const getDatasets = () => {
    return new Promise((resolve) => {
        setTimeout(() => {
            const datasets = []
            const dataTypes = ['image', 'video', 'text', 'table', 'audio', 'custom']
            const names = [
                '猫狗分类图片集', '街景视频数据集', '新闻文本数据集',
                '房价数据表格', '语音指令数据集', '自定义实验数据'
            ]

            for (let i = 1; i <= 25; i++) {
                const dataType = dataTypes[Math.floor(Math.random() * dataTypes.length)]

                datasets.push({
                    id: `dataset-${i}`,
                    name: `${names[Math.floor(Math.random() * names.length)]}${i % 5 === 0 ? ' V2' : ''}`,
                    dataType,
                    description: '这是一个数据集描述，说明了该数据集的内容和用途。可以在这里详细介绍数据集的来源、标注情况等信息。',
                    tags: ['训练集', '测试集', '验证集', '已标注', '未标注'].slice(0, Math.floor(Math.random() * 3) + 1),
                    fileCount: Math.floor(Math.random() * 1000) + 10,
                    size: Math.floor(Math.random() * 1024 * 1024 * 100) + 1024 * 1024,
                    creator: `用户${i % 5 + 1}`,
                    createTime: new Date(Date.now() - Math.floor(Math.random() * 30 * 24 * 3600 * 1000)).toISOString()
                })
            }

            resolve({
                code: 200,
                data: datasets,
                message: 'success'
            })
        }, 800)
    })
}

// 模拟上传数据集
export const uploadDataset = (formData) => {
    return new Promise((resolve) => {
        setTimeout(() => {
            console.log('上传数据集:', formData)
            resolve({
                code: 200,
                data: {
                    id: `dataset-new-${Date.now()}`,
                    name: formData.get('name'),
                    dataType: formData.get('dataType'),
                    description: formData.get('description'),
                    fileCount: formData.get('files')?.length || 0,
                    size: 1024 * 1024 * 10,
                    creator: '当前用户',
                    createTime: new Date().toISOString()
                },
                message: '上传成功'
            })
        }, 1500)
    })
}

// 模拟删除数据集
export const deleteDataset = (id) => {
    return new Promise((resolve) => {
        setTimeout(() => {
            console.log('删除数据集:', id)
            resolve({
                code: 200,
                message: '删除成功'
            })
        }, 300)
    })
}

// 模拟获取数据集文件列表
export const getDatasetFiles = (datasetId) => {
    return new Promise((resolve) => {
        setTimeout(() => {
            const files = []
            const extensions = {
                image: ['jpg', 'png', 'jpeg'],
                video: ['mp4', 'mov'],
                text: ['txt', 'csv'],
                table: ['csv', 'xlsx'],
                audio: ['mp3', 'wav'],
                custom: ['bin', 'dat']
            }

            const dataType = datasetId.includes('image') ? 'image' :
                datasetId.includes('video') ? 'video' :
                    datasetId.includes('text') ? 'text' :
                        datasetId.includes('table') ? 'table' :
                            datasetId.includes('audio') ? 'audio' : 'custom'

            for (let i = 1; i <= 50; i++) {
                const ext = extensions[dataType][Math.floor(Math.random() * extensions[dataType].length)]
                files.push({
                    id: `file-${i}`,
                    name: `file_${i}.${ext}`,
                    size: Math.floor(Math.random() * 1024 * 1024) + 1024,
                    type: ext,
                    modifiedTime: new Date(Date.now() - Math.floor(Math.random() * 7 * 24 * 3600 * 1000)).toISOString(),
                    previewUrl: `https://example.com/preview/${datasetId}/file_${i}.${ext}`
                })
            }

            resolve({
                code: 200,
                data: files,
                message: 'success'
            })
        }, 500)
    })
}
