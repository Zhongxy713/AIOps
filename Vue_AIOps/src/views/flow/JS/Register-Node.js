// 注册节点
import {Graph, Path} from "@antv/x6";
import condition from "@/views/flow/nodeTheme/condition.vue";
import onlyOut from "@/views/flow/nodeTheme/onlyOut.vue";
import onlyIn from "@/views/flow/nodeTheme/onlyIn.vue";
import CustomNode from "@/views/flow/nodeTheme/CustomNode.vue";
const time = new Date().getTime();
Graph.registerNode(
    "dag-condition",
    {
        inherit: "vue-shape",
        width: 180,
        height: 50,
        component: {
            template: `<condition />`,
            components: {
                condition,
            },
        },
        attrs: {
            body: {
                strokeWidth: 1,
                stroke: '#5F95FF',
                fill: '#EFF4FF',
                rx: 6,
                ry: 6
            },
            text: {
                fontSize: 12,
                fill: '#262626'
            }
        },
        ports: {
            groups: {
                top: {
                    position: "top",
                    attrs: {
                        circle: {
                            r: 4,
                            magnet: true,
                            stroke: "#C2C8D5",
                            strokeWidth: 1,
                            fill: "#fff",
                        },
                    },
                },
                bottom: {
                    position: "bottom",
                    attrs: {
                        circle: {
                            r: 4,
                            magnet: true,
                            stroke: "#C2C8D5",
                            strokeWidth: 1,
                            fill: "#fff",
                        },
                    },
                },
                right: {
                    position: "right",
                    label: {
                        position: 'right',  // 标签位置
                    },
                    attrs: {
                        circle: {
                            r: 4,
                            magnet: true,
                            stroke: "#C2C8D5",
                            strokeWidth: 1,
                            fill: "#fff",
                        },
                    },
                },
            },
            items: [
                {
                    id: `in-${time}`,
                    group: "top", // 指定分组名称
                },
                {
                    id: `right-${time}`,
                    group: "right", // 指定分组名称
                    // attrs: {
                    //   text: { text: 'in1' },
                    // },
                },
                {
                    id: `out-${time}-1`,
                    group: "bottom", // 指定分组名称
                },
                {
                    id: `out-${time}-2`,
                    group: "bottom", // 指定分组名称
                },
            ],
        }
    },
    true
);

Graph.registerNode(
    "dag-onlyOut",
    {
        inherit: "vue-shape",
        width: 180,
        height: 50,
        component: {
            template: `<onlyOut />`,
            components: {
                onlyOut,
            },
        },
        attrs: {
            body: {
                strokeWidth: 1,
                stroke: '#5F95FF',
                fill: '#EFF4FF',
                rx: 6,
                ry: 6
            },
            text: {
                fontSize: 12,
                fill: '#262626'
            }
        },
        ports: {
            groups: {
                top: {
                    position: "top",
                    attrs: {
                        circle: {
                            r: 4,
                            magnet: true,
                            stroke: "#C2C8D5",
                            strokeWidth: 1,
                            fill: "#fff",
                        },
                    },
                },
                bottom: {
                    position: "bottom",
                    attrs: {
                        circle: {
                            r: 4,
                            magnet: true,
                            stroke: "#C2C8D5",
                            strokeWidth: 1,
                            fill: "#fff",
                        },
                    },
                },
                right: {
                    position: "right",
                    label: {
                        position: 'right',  // 标签位置
                    },
                    attrs: {
                        circle: {
                            r: 4,
                            magnet: true,
                            stroke: "#C2C8D5",
                            strokeWidth: 1,
                            fill: "#fff",
                        },
                    },
                },
            },
            items: [
                {
                    id: `out-${time}`,
                    group: 'bottom'
                },
                {
                    id: `right-${time}`,
                    group: 'right',
                    // attrs: {
                    //   text: { text: 'out1' },
                    // },
                },
            ]
        }
    },
    true
);

Graph.registerNode(
    "dag-onlyIn",
    {
        inherit: "vue-shape",
        width: 180,
        height: 50,
        component: {
            template: `<onlyIn />`,
            components: {
                onlyIn,
            },
        },
        attrs: {
            body: {
                strokeWidth: 1,
                stroke: '#5F95FF',
                fill: '#EFF4FF',
                rx: 6,
                ry: 6
            },
            text: {
                fontSize: 12,
                fill: '#262626'
            }
        },
        ports: {
            groups: {
                // 输入链接桩群组定义
                top: {
                    position: "top",
                    attrs: {
                        circle: {
                            r: 4,
                            magnet: true,
                            stroke: "#C2C8D5",
                            strokeWidth: 1,
                            fill: "#fff",
                        },
                    },
                },
                bottom: {
                    position: "bottom",
                    attrs: {
                        circle: {
                            r: 4,
                            magnet: true,
                            stroke: "#C2C8D5",
                            strokeWidth: 1,
                            fill: "#fff",
                        },
                    },
                },
                right: {
                    position: "right",
                    label: {
                        position: 'right',  // 标签位置
                    },
                    attrs: {
                        circle: {
                            r: 4,
                            magnet: true,
                            stroke: "#C2C8D5",
                            strokeWidth: 1,
                            fill: "#fff",
                        },
                    },
                },
            },
            items: [
                {
                    id: `in-${time}`,
                    group: 'top'
                },
                {
                    id: `right-${time}`,
                    group: 'right',
                    // attrs: {
                    //   text: { text: 'in1' },
                    // },
                },
            ]
        }
    },
    true
);

Graph.registerNode(
    "dag-node",
    {
        inherit: "vue-shape",
        width: 180,
        height: 60,
        component: {
            template: `<CustomNode />`,
            components: {
                CustomNode,
            },
        },
        attrs: {
            body: {
                strokeWidth: 1,
                stroke: '#5F95FF',
                fill: '#EFF4FF',
                rx: 6,
                ry: 6
            },
            text: {
                fontSize: 12,
                fill: '#262626'
            }
        },
        ports: {
            groups: {
                top: {
                    position: "top",
                    attrs: {
                        circle: {
                            r: 4,
                            magnet: true,
                            stroke: "#C2C8D5",
                            strokeWidth: 1,
                            fill: "#fff",
                        },
                    },
                },
                bottom: {
                    position: "bottom",
                    attrs: {
                        circle: {
                            r: 4,
                            magnet: true,
                            stroke: "#C2C8D5",
                            strokeWidth: 1,
                            fill: "#fff",
                        },
                    },
                },
                right: {
                    position: "right",
                    label: {
                        position: 'right',  // 标签位置
                    },
                    attrs: {
                        circle: {
                            r: 4,
                            magnet: true,
                            stroke: "#C2C8D5",
                            strokeWidth: 1,
                            fill: "#fff",
                        },
                    },
                },
            },
            items: [
                {
                    id: `in-${time}`,
                    group: "top", // 指定分组名称
                },
                {
                    id: `right-${time}`,
                    group: "right", // 指定分组名称
                    // attrs: {
                    //   text: { text: 'in1' },
                    // },
                },
                {
                    id: `out-${time}`,
                    group: "bottom", // 指定分组名称
                },
            ],
        }
    },
    true
);


Graph.registerNode('menu-node', {
    inherit: 'rect',
    width: 180,
    height: 30,
    markup: [
        {
            tagName: 'rect',
            selector: 'body'
        },
        {
            tagName: 'image'
        },
        {
            tagName: 'text',
            selector: 'label'
        }
    ],
    attrs: {
        body: {
            stroke: '#fff',
            fill: '#fff'
        },
        image: {
            width: 26,
            height: 26,
            refY: 1,
            refX: 5
        },
        label: {
            refX: 60,
            textAnchor: 'middle',
            textVerticalAnchor: 'middle',
            fontSize: 14,
            fill: '#333'
        }
    }
})

Graph.registerConnector(
    'algo-connector',
    (s, e) => {
        const offset = 4
        const deltaY = Math.abs(e.y - s.y)
        const control = Math.floor((deltaY / 3) * 2)

        const v1 = { x: s.x, y: s.y + offset + control }
        const v2 = { x: e.x, y: e.y - offset - control }

        return Path.normalize(
            `M ${s.x} ${s.y}
       L ${s.x} ${s.y + offset}
       C ${v1.x} ${v1.y} ${v2.x} ${v2.y} ${e.x} ${e.y - offset}
       L ${e.x} ${e.y}
      `,
        )
    },
    true,
)


Graph.registerEdge(
    "dag-edge",
    {
        inherit: "edge",
        attrs: {
            line: {
                stroke: "#C2C8D5",
                strokeWidth: 2,
                targetMarker: {
                    name: "block",
                    width: 12,
                    height: 8,
                },
            },
        },
    },
    true
);
// Graph.registerConnector(
//     "algo-connector",
//     (s, e) => {
//         const offset = 4;
//         const deltaY = Math.abs(e.y - s.y);
//         const control = Math.floor((deltaY / 3) * 2);
//
//         const v1 = { x: s.x, y: s.y + offset + control };
//         const v2 = { x: e.x, y: e.y - offset - control };
//
//         return Path.normalize(
//             `M ${s.x} ${s.y}
//            L ${s.x} ${s.y + offset}
//            C ${v1.x} ${v1.y} ${v2.x} ${v2.y} ${e.x} ${e.y - offset}
//            L ${e.x} ${e.y}
//           `
//         );
//     },
//     true
// );
