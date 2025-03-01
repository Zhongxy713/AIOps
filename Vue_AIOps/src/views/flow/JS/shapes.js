// import { Graph } from '@antv/x6'


// const time = new Date().getTime();

export default function registerShapes(item) {
  switch (item.type) {
    case "output":
      return {
        shape:'dag-onlyOut',
        data: item,

      }
    case "onlyIn":
      return {
        shape: 'dag-onlyIn',
        data: item,

      }
    case "database" :
      return {
        shape: 'dag-node',
        data: item,

      }
    case "condition" :
      return {
        shape:'dag-condition',
        data: item,

      }
  }
}

// // 注册菜单节点
// const menu_node = {
//     x:'',
//     y:'',
//     shape:'menu-node',
//     inherit: 'vue-shape',
//     width: 180,
//     height: 50,
//     markup: [
//       {
//         tagName: 'rect',
//         selector: 'body'
//       },
//       {
//         tagName: 'image'
//       },
//       {
//         tagName: 'text',
//         selector: 'label'
//       }
//     ],
//     attrs: {
//       body: {
//         stroke: '#fff',
//         fill: '#fff'
//       },
//       image: {
//         width: 26,
//         height: 26,
//         refY: 1,
//         refX: 5
//       },
//       label: {
//         refX: 60,
//         textAnchor: 'middle',
//         textVerticalAnchor: 'middle',
//         fontSize: 14,
//         fill: '#333'
//       }
//     }
//   }
//
// // // 注册拖拽放置节点
// // const dag_condition = {
// //     shape:'dag-condition',
// //     inherit: 'vue-shape',
// //     width: 180,
// //     height: 50,
// //     component: () => import('./condition.vue'),
// //     attrs: {
// //       body: {
// //         rx: 6,
// //         ry: 6
// //       }
// //     },
// //     ports: {
// //       groups: {
// //         top: {
// //           position: 'top',
// //           attrs: {
// //             circle: {
// //               r: 4,
// //               magnet: true,
// //               stroke: '#5F95FF',
// //               strokeWidth: 1,
// //               fill: '#fff',
// //               style: {
// //                 visibility: 'hidden'
// //               }
// //             }
// //           }
// //         },
// //         right: {
// //           position: 'right',
// //           attrs: {
// //             circle: {
// //               r: 4,
// //               magnet: true,
// //               stroke: '#5F95FF',
// //               strokeWidth: 1,
// //               fill: '#fff',
// //               style: {
// //                 visibility: 'hidden'
// //               }
// //             }
// //           }
// //         },
// //         bottom: {
// //           position: 'bottom',
// //           attrs: {
// //             circle: {
// //               r: 4,
// //               magnet: true,
// //               stroke: '#5F95FF',
// //               strokeWidth: 1,
// //               fill: '#fff',
// //               style: {
// //                 visibility: 'hidden'
// //               }
// //             }
// //           }
// //         },
// //         // left: {
// //         //   position: 'left',
// //         //   attrs: {
// //         //     circle: {
// //         //       r: 4,
// //         //       magnet: true,
// //         //       stroke: '#5F95FF',
// //         //       strokeWidth: 1,
// //         //       fill: '#fff',
// //         //       style: {
// //         //         visibility: 'hidden'
// //         //       }
// //         //     }
// //         //   }
// //         // }
// //       },
// //       items: [
// //         {
// //           id: `in-${time}`,
// //           group: 'top'
// //         },
// //         {
// //           id: `in-right-${time}`,
// //           group: 'right'
// //         },
// //         {
// //           id: `out-${time}`,
// //           group: 'bottom'
// //         },
// //         {
// //           id: `out-right-${time}`,
// //           group: 'right'
// //         }
// //       ]
// //     }
// //   }
//
// // 注册拖拽放置节点
// const dag_output = {
//     x:'',
//     y:'',
//     shape:'dag-onlyOut',
//     inherit: 'vue-shape',
//     width: 180,
//     height: 50,
//     component: () => import('./onlyOut.vue'),
//     attrs: {
//       body: {
//         rx: 6,
//         ry: 6
//       }
//     },
//     ports: {
//       groups: {
//         bottom: {
//           position: 'bottom',
//           attrs: {
//             circle: {
//               r: 4,
//               magnet: true,
//               stroke: '#5F95FF',
//               strokeWidth: 1,
//               fill: '#fff',
//               style: {
//                 visibility: 'hidden'
//               }
//             }
//           }
//         },
//         right: {
//           position: 'right',
//           attrs: {
//             circle: {
//               r: 4,
//               magnet: true,
//               stroke: '#5F95FF',
//               strokeWidth: 1,
//               fill: '#fff',
//               style: {
//                 visibility: 'hidden'
//               }
//             }
//           }
//         },
//       },
//       items: [
//         {
//           id: `right-${time}`,
//           group: 'right'
//         },
//         {
//           id: `out-${time}`,
//           group: 'bottom'
//         },
//       ]
//     }
//   }
//
// // 注册拖拽放置节点
// const dag_onlyIn =  {
//     x:'',
//     y:'',
//     shape: 'dag_onlyIn',
//     inherit: 'vue-shape',
//     width: 180,
//     height: 50,
//     component: () => import('./onlyIn.vue'),
//     attrs: {
//       body: {
//         rx: 6,
//         ry: 6
//       }
//     },
//     ports: {
//       groups: {
//         // 输入链接桩群组定义
//         top: {
//           position: 'top',
//           attrs: {
//             circle: {
//               r: 6,
//               magnet: true,
//               stroke: '#31d0c6',
//               strokeWidth: 2,
//               fill: '#fff',
//               connectionCount: 1 // 自定义属性，控制连接桩可连接多少条边
//             }
//           }
//         },
//         right: {
//           position: 'right',
//           attrs: {
//             circle: {
//               r: 4,
//               magnet: true,
//               stroke: '#5F95FF',
//               strokeWidth: 1,
//               fill: '#fff',
//               style: {
//                 visibility: 'hidden'
//               }
//             }
//           }
//         },
//         // 输出链接桩群组定义
//         // out: {
//         //   position: 'bottom',
//         //   attrs: {
//         //     circle: {
//         //       r: 6,
//         //       magnet: true,
//         //       stroke: '#31d0c6',
//         //       strokeWidth: 2,
//         //       fill: '#fff',
//         //       connectionCount: 1 // 自定义属性，控制连接桩可连接多少条边
//         //     }
//         //   }
//         // }
//       },
//       items: [
//         {
//           id: `in-${time}`,
//           group: 'in'
//         },
//         {
//           id: `in-right-${time}`,
//           group: 'right'
//         },
//       ]
//     }
//   }
// // 注册拖拽放置节点
// const dag_node = {
//     x:'',
//     y:'',
//     shape: 'dag-node',
//     inherit: 'vue-shape',
//     width: 180,
//     height: 60,
//     component: () => import('./CustomNode.vue'),
//     attrs: {
//       body: {
//         rx: 6,
//         ry: 6
//       }
//     },
//     ports: {
//       groups: {
//         top: {
//           position: 'top',
//           attrs: {
//             circle: {
//               r: 4,
//               magnet: true,
//               stroke: '#5F95FF',
//               strokeWidth: 1,
//               fill: '#fff',
//               style: {
//                 visibility: 'hidden'
//               }
//             }
//           }
//         },
//         bottom: {
//           position: 'bottom',
//           attrs: {
//             circle: {
//               r: 4,
//               magnet: true,
//               stroke: '#5F95FF',
//               strokeWidth: 1,
//               fill: '#fff',
//               style: {
//                 visibility: 'hidden'
//               }
//             }
//           }
//         },
//         right: {
//           position: 'right',
//           attrs: {
//             circle: {
//               r: 4,
//               magnet: true,
//               stroke: '#5F95FF',
//               strokeWidth: 1,
//               fill: '#fff',
//               style: {
//                 visibility: 'hidden'
//               }
//             }
//           }
//         },
//       },
//       items: [
//         {
//           id: `in-${time}`,
//           group: "top", // 指定分组名称
//         },
//         {
//           id: `in-right-${time}`,
//           group: "right", // 指定分组名称
//         },
//         {
//           id: `out-${time}`,
//           group: "bottom", // 指定分组名称
//         },
//         {
//           id: `out-right-${time}`,
//           group: "right", // 指定分组名称
//         },
//       ],
//     }
//   }
//
// // 注册拖拽放置节点
// const dag_condition = {
//     x:'',
//     y:'',
//     shape:'dag-condition',
//     inherit: 'vue-shape',
//     width: 180,
//     height: 50,
//     component: () => import('./condition.vue'),
//     attrs: {
//       body: {
//         rx: 6,
//         ry: 6
//       }
//     },
//     ports: {
//       groups: {
//         top: {
//           position: "top",
//           attrs: {
//             circle: {
//               r: 4,
//               magnet: true,
//               stroke: "#C2C8D5",
//               strokeWidth: 1,
//               fill: "#fff",
//             },
//           },
//         },
//         bottom: {
//           position: "bottom",
//           attrs: {
//             circle: {
//               r: 4,
//               magnet: true,
//               stroke: "#C2C8D5",
//               strokeWidth: 1,
//               fill: "#fff",
//             },
//           },
//         },
//       },
//       items: [
//         {
//           id: `in-${time}`,
//           group: "top", // 指定分组名称
//         },
//         {
//           id: `in-right-${time}`,
//           group: "right", // 指定分组名称
//         },
//         {
//           id: `out-${time}-1`,
//           group: "bottom", // 指定分组名称
//         },
//         {
//           id: `out-right-${time}-1`,
//           group: "right", // 指定分组名称
//         },
//         {
//           id: `out-${time}-2`,
//           group: "bottom", // 指定分组名称
//         },
//         {
//           id: `out-right-${time}-2`,
//           group: "right", // 指定分组名称
//         },
//       ],
//     }
//   }
