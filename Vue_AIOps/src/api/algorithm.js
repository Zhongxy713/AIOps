// 模拟获取算法组件列表
export const getAlgorithmComponents = () => {
    return new Promise((resolve) => {
        setTimeout(() => {
            const components = []
            const categories = ['ml', 'dl', 'stats', 'preprocess']
            const names = [
                '线性回归', '逻辑回归', '决策树', '随机森林',
                'SVM', 'K-Means', '神经网络', 'CNN', 'RNN',
                '数据标准化', '缺失值处理', '特征选择'
            ]

            for (let i = 1; i <= 25; i++) {
                const category = categories[Math.floor(Math.random() * categories.length)]
                const inputCount = Math.floor(Math.random() * 5) + 1
                const outputCount = Math.floor(Math.random() * 3) + 1

                components.push({
                    id: `algo-${i}`,
                    name: names[Math.floor(Math.random() * names.length)],
                    category,
                    version: `${Math.floor(Math.random() * 2) + 1}.0.0`,
                    description: '这是一个算法组件的描述，说明了该组件的功能和用途。',
                    inputs: Array(inputCount).fill(0).map((_, idx) => ({
                        name: `input_${idx + 1}`,
                        type: ['number', 'string', 'array'][Math.floor(Math.random() * 3)],
                        description: `输入参数${idx + 1}的描述`,
                        required: Math.random() > 0.3
                    })),
                    outputs: Array(outputCount).fill(0).map((_, idx) => ({
                        name: `output_${idx + 1}`,
                        type: ['number', 'string', 'object'][Math.floor(Math.random() * 3)],
                        description: `输出参数${idx + 1}的描述`
                    })),
                    dependencies: ['numpy', 'pandas'].slice(0, Math.floor(Math.random() * 2) + 1),
                    createTime: new Date(Date.now() - Math.floor(Math.random() * 30 * 24 * 3600 * 1000)).toLocaleString()
                })
            }

            resolve({
                code: 200,
                data: components,
                message: 'success'
            })
        }, 800)
    })
}

// 模拟保存算法组件
export const saveAlgorithmComponent = (component) => {
    return new Promise((resolve) => {
        setTimeout(() => {
            console.log('保存组件:', component)
            resolve({
                code: 200,
                message: '保存成功'
            })
        }, 500)
    })
}

// 模拟删除算法组件
export const deleteAlgorithmComponent = (id) => {
    return new Promise((resolve) => {
        setTimeout(() => {
            console.log('删除组件:', id)
            resolve({
                code: 200,
                message: '删除成功'
            })
        }, 300)
    })
}

// 模拟获取算法模型列表
export const getAlgorithmModels = () => {
    return new Promise((resolve) => {
        setTimeout(() => {
            const algorithms = []
            const frameworks = ['tensorflow', 'pytorch', 'sklearn', 'xgboost', 'keras']
            const names = [
                '线性回归', '逻辑回归', '决策树', '随机森林', 'SVM',
                'K-Means', '神经网络', 'CNN', 'RNN', 'LSTM',
                '数据标准化', '特征工程', '图像分类', '文本分类'
            ]

            for (let i = 1; i <= 25; i++) {
                const isPreset = i % 3 === 0
                const framework = frameworks[Math.floor(Math.random() * frameworks.length)]

                algorithms.push({
                    id: `algo-${i}`,
                    name: `${names[Math.floor(Math.random() * names.length)]}${i % 5 === 0 ? ' (优化版)' : ''}`,
                    framework,
                    version: `${Math.floor(Math.random() * 2) + 1}.0.${Math.floor(Math.random() * 10)}`,
                    description: '这是一个算法模型的描述，说明了该模型的功能和用途。可以在这里详细介绍算法的原理、适用场景等信息。',
                    tags: ['分类', '回归', '深度学习', '机器学习'].slice(0, Math.floor(Math.random() * 3) + 1),
                    author: isPreset ? '平台管理员' : `用户${i}`,
                    isPreset,
                    isFavorite: i % 4 === 0,
                    updateTime: new Date(Date.now() - Math.floor(Math.random() * 30 * 24 * 3600 * 1000)).toISOString(),
                    pythonVersion: '3.8',
                    dependencies: [
                        { name: 'numpy', version: '>=1.0.0', source: 'pypi' },
                        { name: framework, version: 'latest', source: 'pypi' }
                    ],
                    inputParams: [
                        { name: 'input_data', type: 'file', required: true, description: '输入数据文件' }
                    ],
                    outputParams: [
                        { name: 'output_model', type: 'file', description: '输出模型文件' }
                    ]
                })
            }

            resolve({
                code: 200,
                data: algorithms,
                message: 'success'
            })
        }, 800)
    })
}

// 模拟保存算法模型
export const saveAlgorithmModel = (algorithm) => {
    return new Promise((resolve) => {
        setTimeout(() => {
            console.log('保存算法:', algorithm)
            resolve({
                code: 200,
                message: '保存成功'
            })
        }, 500)
    })
}

// 模拟删除算法模型
export const deleteAlgorithmModel = (id) => {
    return new Promise((resolve) => {
        setTimeout(() => {
            console.log('删除算法:', id)
            resolve({
                code: 200,
                message: '删除成功'
            })
        }, 300)
    })
}
