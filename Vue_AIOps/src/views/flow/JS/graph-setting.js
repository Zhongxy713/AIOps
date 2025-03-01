import { Shape } from '@antv/x6'
import  './Register-Node'
const graphSettings = (cElement) => {
  return {

    // // 初始化画布
      container: cElement,
      width: cElement.offsetWidth,
      height: cElement.offsetHeight,
      grid: true,
      autoResize: true,
      translating: { restrict: true },
      panning: {
          enabled: true,
          eventTypes: ['leftMouseDown', 'mouseWheel'],
      },
      mousewheel: {
          enabled: true,
          modifiers: 'ctrl',
          zoomAtMousePosition: true,
          factor: 1.1,
          maxScale: 1.5,
          minScale: 0.5,
      },
      highlighting: {
          magnetAdsorbed: {
              name: 'stroke',
              args: {
                  attrs: {
                      fill: '#fff',
                      stroke: '#31d0c6',
                      strokeWidth: 4,
                  },
              },
          },
      },
      connecting: {
          snap: true,
          allowBlank: false,
          allowLoop: false,
          highlight: true,
          connector: 'algo-connector',
          connectionPoint: 'anchor',
          anchor: 'center',
          validateMagnet({ magnet }) {
              return magnet.getAttribute('port-group') !== 'top'
          },
          onToolItemCreated({ tool }) {
              const handle = tool
              const options = handle.options
              if (options && options.index % 2 === 1) {
                  tool.setAttrs({ fill: 'red' })
              }
          },
          createEdge() {
              return new Shape.Edge({
                  shape: 'dag-edge',
                  attrs: {
                      line: {
                          stroke: '#A2B1C3',
                          strokeWidth: 2,
                          targetMarker: {
                              name: 'block',
                              width: 12,
                              height: 8
                          },
                      },
                  },
                  zIndex: -1,
              })
          },
      },
      resizing: true,
      rotating: true,
      snapline: true,
      keyboard: true,
      clipboard: true,
      selecting: {
          enabled: true,
          multiple: true,
          rubberEdge: true,
          rubberNode: true,
          modifiers: 'shift',
          rubberband: true,
          showNodeSelectionBox: true,
      },
      // grid: true,
      // autoResize: true,
      // translating: { restrict: true },
      // mousewheel: {
      //     enabled: true,
      //     zoomAtMousePosition: true,
      //     modifiers: 'ctrl',
      //     minScale: 0.5,
      //     maxScale: 3,
      // },
      // connecting: {
      //     router: {
      //         name: 'manhattan',
      //         args: {
      //             padding: 1,
      //         },
      //     },
      //     connector: 'algo-connector',
      //     anchor: 'center',
      //     connectionPoint: 'anchor',
      //     allowBlank: false,
      //     snap: {
      //         radius: 20,
      //     },
      //     createEdge() {
      //         return new Shape.Edge({
      //                   shape: 'dag-edge',
      //                   attrs: {
      //                       line: {
      //                           strokeDasharray: '5 5',
      //                       },
      //                   },
      //                   zIndex: -1,
      //               })
      //     },
      //     validateConnection({ targetMagnet }) {
      //         return !!targetMagnet
      //     },
      // },
      // onToolItemCreated({ tool }) {
      //     const handle = tool
      //     const options = handle.options
      //     if (options && options.index % 2 === 1) {
      //         tool.setAttrs({ fill: 'red' })
      //     }
      // },
      // highlighting: {
      //     magnetAdsorbed: {
      //         name: 'stroke',
      //         args: {
      //             attrs: {
      //                 fill: '#5F95FF',
      //                 stroke: '#5F95FF',
      //             },
      //         },
      //     },
      // },
      // resizing: true,
      // rotating: true,
      // selecting: {
      //     enabled: true,
      //     rubberband: true,
      //     showNodeSelectionBox: true,
      // },
      // snapline: true,
      // keyboard: true,
      // clipboard: true
  }
}

export default graphSettings


// 连线 label 设置
export const configEdgeLabel = (labelText, fontColor, fill, stroke) => {
    if(!labelText) return { attrs: { labelText: { text: '' }, labelBody: { fill: '', stroke: '' } } }
    return {
        markup: [
            {
                tagName: 'rect',
                selector: 'labelBody',
            },
            {
                tagName: 'text',
                selector: 'labelText',
            },
        ],
        attrs: {
            labelText: {
                text: labelText || '',
                fill: fontColor || '#333',
                textAnchor: 'middle',
                textVerticalAnchor: 'middle',
            },
            labelBody: {
                ref: 'labelText',
                refX: -8,
                refY: -5,
                refWidth: '100%',
                refHeight: '100%',
                refWidth2: 16,
                refHeight2: 10,
                stroke: stroke || '#555',
                fill: fill || '#fff',
                strokeWidth: 2,
                rx: 5,
                ry: 5,
            },
        }
    }
}
