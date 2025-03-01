import { Graph, Addon } from '@antv/x6'
import '@antv/x6-vue-shape'
import './shapes'
import './Register-Node'
import graphSettings from './graph-setting'
// import { createNodeData } from './types'
import registerShapes from "@/views/flow/JS/shapes";

let graph
let stencil

export default {

    create(cElement) {
        if (!cElement) throw new Error("Can't create graph, no element")

        graph = new Graph(graphSettings(cElement))
        graph.centerContent()
        this.initEvents(cElement)
        console.log('graph', graph)
        return graph
    },

    initStencil(sElement, menuData) {
        const tmpMenuData = this.transformMenuData(menuData)

        console.log('temMenuData', tmpMenuData)
        stencil = new Addon.Stencil({
            collapsable: true,
            // eslint-disable-next-line no-unused-vars
            getDropNode(node, options) {

                console.log('node', node)
                return graph.createNode(registerShapes(node.data))
            },
            groups: tmpMenuData.groups,
            layoutOptions: {
                columns: 1,
                columnWidth: 'auto',
                rowHeight: 'auto',
                dx: 5,
                dy: 5,
                resizeToFit: true
            },
            notFoundText: '无数据',
            placeholder: '搜索',
            search: (cell, keyword) => {
                if (keyword) {
                    return cell?.attr('text/text')?.includes(keyword)
                }
                return true
            },
            stencilGraphHeight: 180,
            stencilGraphWidth: 220,
            target: graph,
            title: '组件列表'
        })

        sElement?.appendChild(stencil.container)
        this.initStencilNode(tmpMenuData)
        return stencil
    },

    initStencilNode(subMenuData) {
        Object.keys(subMenuData.items).forEach((key) => {
            stencil.load(subMenuData.items[key], key)
        })
    },

    transformMenuData(menuGroups) {
        const menuData = {
            groups: [],
            items: {}
        }

        menuGroups?.forEach((menuGroup) => {
            menuData.groups.push({
                title: menuGroup.nodeTitle,
                name: menuGroup.nodeName
            })

            menuData.items[menuGroup.nodeName] = []

            menuGroup?.children?.forEach((child) => {
                menuData.items[menuGroup.nodeName].push({
                    shape: 'menu-node',
                    label: child.nodeTitle,
                    data: child,
                    attrs: {
                        image: {
                            'xlink:href': child.img
                        }
                    }
                })
            })
        })
        console.log('menuData', menuData)
        return menuData
    },

    initEvents(cElement) {
        const showPorts = (ports, show) => {
            for (let i = 0, len = ports.length; i < len; i += 1) {
                ports[i].style.visibility = show ? 'visible' : 'hidden'
            }
        }


        graph.on('node:mouseenter', () => {
            const container = cElement || null
            const ports = container.querySelectorAll('.x6-port-body')

            showPorts(ports, true)
        })

        graph.on('node:mouseleave', () => {
            const container = cElement || null
            const ports = container.querySelectorAll('.x6-port-body')

            showPorts(ports, false)
        })

        graph.bindKey(['meta+c', 'ctrl+c'], () => {
            const cells = graph.getSelectedCells()
            if (cells.length) {
                graph.copy(cells)
            }
            return false
        })

        graph.bindKey(['meta+x', 'ctrl+x'], () => {
            const cells = graph.getSelectedCells()
            if (cells.length) {
                graph.cut(cells)
            }
            return false
        })

        graph.bindKey(['meta+v', 'ctrl+v'], () => {
            if (!graph.isClipboardEmpty()) {
                const cells = graph.paste({ offset: 32 })
                graph.cleanSelection()
                graph.select(cells)
            }
            return false
        })

        graph.bindKey(['meta+z', 'ctrl+z'], () => {
            if (graph.history.canUndo()) {
                graph.history.undo()
            }
            return false
        })

        graph.bindKey(['meta+shift+z', 'ctrl+shift+z'], () => {
            if (graph.history.canRedo()) {
                graph.history.redo()
            }
            return false
        })

        graph.bindKey(['meta+a', 'ctrl+a'], () => {
            const nodes = graph.getNodes()
            if (nodes) {
                graph.select(nodes)
            }
        })

        graph.bindKey(['backspace', 'delete'], () => {
            const cells = graph.getSelectedCells()
            if (cells.length) {
                graph.removeCells(cells)
            }
        })
    },

    reloadGraph(graphData) {
        graph.fromJSON(graphData)
    }
}
