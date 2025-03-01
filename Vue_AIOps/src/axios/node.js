import request from '@/utils/request'

export function getAllNodes() {
  return request({
    url: '/node',
    method: 'get'
  })
}
export function getNodeData(data) {
  return request({
    url: '/node/findNodeData',
    method: 'get',
    params: {
      name: data
    }
  })
}

// 获得节点参数
export function getNodeParam(data) {
  return request({
    url: '/nodeLibrary/page',
    method: 'get',
    params: {
      pageNum: 1,
      pageSize: 5,
      name: data
    }
  })
}
// 保存节点参数
export function saveParamData(data) {
  return request({
    url: '/nodeLibrary',
    method: 'post',
    data
  })
}
// 保存算法管道模型
export function saveAPMData(data) {
  return request({
    url: '/algorithmic-pipeline-models',
    method: 'post',
    data
  })
}

// 获得算法管道模型列表
export function getAPMData(data) {
  return request({
    url: '/algorithmic-pipeline-models/page',
    method: 'get',
    params: data
  })
}

// 获得算法管道模型JSON
export function getAPMJson(apmId) {
  return request({
    url: '/algorithmic-pipeline-models/getAPMJson/'+ apmId,
    method: 'get',
  })
}
