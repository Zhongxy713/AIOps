export function createMenuItem(id, name, img) {
  return {
    id: id,
    name: name,
    img: img
  }
}

export function createMenuGroup(title, name, children) {
  return {
    title: title,
    name: name,
    children: children
  }
}

export function createMenuData(groups, items) {
  return {
    groups: groups,
    items: items
  }
}

export function createNodeData(node, shape) {
  return {
    shape: shape,
    data: {
      label: node.label || 'no name',
      name: node.data.name,
      status: '', //  初始化节点
      nodeData: ''
    }
  }
}
