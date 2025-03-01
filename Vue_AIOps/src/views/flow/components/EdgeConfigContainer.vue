<template>
  <a-tabs type="card" defaultActiveKey="1" size="small">
    <a-tab-pane key="1" tab="线条">
      <div class="form-main">
        <el-form ref="edgeForm" :model="lineForm" label-width="80px">
          <el-form-item label="线条颜色">
            <el-color-picker v-model="lineForm.stroke" size="small"  @change="changeEdgeStroke"></el-color-picker>
          </el-form-item>
          <el-form-item label="线条样式">
            <el-select v-model="lineForm.connector" size="small" placeholder="请选择" @change="changeEdgeConnector">
              <el-option label="直角" value="normal"></el-option>
              <el-option label="圆角" value="rounded"></el-option>
              <el-option label="平滑" value="smooth"></el-option>
              <el-option label="跳线(两线交叉)" value="jumpover"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="线条宽度">
            <el-input-number v-model="lineForm.strokeWidth" size="small" @change="changeEdgeStrokeWidth" :min="2" :step="2" :max="6" label="线条宽度"></el-input-number>
          </el-form-item>
          <el-form-item label="箭头方向" >
            <el-select v-model="value" placeholder="请选择" @change="handleArrow">
              <el-option
                  v-for="item in arrow"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="流动线条">
            <el-switch v-model="lineForm.isAnit" @change="changeEdgeAnit"></el-switch>
          </el-form-item>
          <el-form-item label="调整线条">
            <el-switch v-model="lineForm.isTools" @change="changeEdgeTools"></el-switch>
          </el-form-item>
        </el-form>
      </div>
    </a-tab-pane>
    <a-tab-pane key="2" tab="规则" v-if="lineForm.isAnit">
      <el-form ref="edgeForm" :model="ruleForm" label-width="80px">
      <el-form-item label="增加规则">
<!--        <el-input v-model="labelText" size="small" placeholder="标签文字，空则没有" ></el-input>-->
        <el-select v-model="labelText" placeholder="规则">
          <el-option
              v-for="item in options"
              :key="item.value"
              :label="item.label"
              :value="item.value">
          </el-option>
        </el-select>
<!--        <div class="label-style">-->
<!--          <p>字体颜色：<el-color-picker v-model="labelForm.fontColor" size="mini" ></el-color-picker></p>-->
<!--          <p>背景颜色：<el-color-picker v-model="labelForm.fill" size="mini" ></el-color-picker></p>-->
<!--          <p>描边颜色：<el-color-picker v-model="labelForm.stroke" size="mini" ></el-color-picker></p>-->
<!--        </div>-->
      </el-form-item>
      <el-form-item label="组件S">
        <el-cascader :options="params"></el-cascader>
        <el-input v-model="Svalue" size="small" placeholder="参数设置" ></el-input>

      </el-form-item>
        <el-form-item label="组件T">
          <el-cascader :options="params"></el-cascader>
          <el-input v-model="Nvalue" size="small" placeholder="参数设置" ></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="changeEdgeLabel(labelText, labelForm.fontColor, labelForm.fill, labelForm.stroke)">保存</el-button>
        </el-form-item>
      </el-form>
    </a-tab-pane>
  </a-tabs>
</template>

<script>
import {Edge} from '@antv/x6'
import {configEdgeLabel} from "@/views/flow/JS/graph-setting";
export default {
  name: 'EdgeConfigContainer',
  props: {
    edge: Edge
  },
  data () {
    return {
      curEdge: {},
      // form: this.$form.createForm(this, {name: 'configPanel'}),
      curLabel: '',
      labelText:'',
      lineForm: {
        stroke: '#A2B1C3',
        isAnit: false,
        isTools: false,

      },
      ruleForm: {

      },
      labelForm: {
        fontColor: '#333',
        fill: '#FFF',
        stroke: '#555'
      },
      value: '',
      arrow: [{
        value: 1,
        label: '正向'
      }, {
        value: 2,
        label: '逆向'
      }, {
        value: 3,
        label: '双向'
      }],
      options: [{
        value: '参数调整',
        label: '参数调整'
      }, {
        value: '版本变更',
        label: '版本变更'
      }, {
        value: '组件替换',
        label: '组件替换'
      }, {
        value: '增加组件',
        label: '增加组件'
      }, {
        value: '流程调整',
        label: '流程调整'
      }],
      params: [{
        value: 'zujian',
        label: '图片数据',
        children: [{
          value: 'metaData',
          label: 'metaData',
          children: [{
            value: 'layout',
            label: '组件名称'   //组件名称、镜像名称、组件描述、组件版本
          }, {
            value: 'color',
            label: '镜像名称'
          }, {
            value: 'typography',
            label: '组件描述'
          }, {
            value: 'icon',
            label: '组件版本'
          }]
        },{
          value: 'Data',
          label: 'Data',
          children: [{
            value: 'layout',
            label: 'Input'   //输入输出参数、超参数、数据集、环境依赖配置、文件路径
          }, {
            value: 'color',
            label: 'Output'
          }, {
            value: 'typography',
            label: 'Parameter'
          }, {
            value: 'icon',
            label: 'Dataset'
          }, {
            value: 'environment',
            label: 'Environment'
          }, {
            value: 'path',
            label: 'Path'
          }]
        },]
      },{
        value: 'tpcl',
        label: '图片处理',
        children: [{
          value: 'metaData',
          label: 'metaData',
          children: [{
            value: 'layout',
            label: '组件名称'   //组件名称、镜像名称、组件描述、组件版本
          }, {
            value: 'color',
            label: '镜像名称'
          }, {
            value: 'typography',
            label: '组件描述'
          }, {
            value: 'icon',
            label: '组件版本'
          }]
        },{
          value: 'Data',
          label: 'Data',
          children: [{
            value: 'layout',
            label: 'Input'   //输入输出参数、超参数、数据集、环境依赖配置、文件路径
          }, {
            value: 'color',
            label: 'Output'
          }, {
            value: 'typography',
            label: 'Parameter'
          }, {
            value: 'icon',
            label: 'Dataset'
          }, {
            value: 'environment',
            label: 'Environment'
          }, {
            value: 'path',
            label: 'Path'
          }]
        },]
      },{
        value: 'tpbj',
        label: '图片比较',
        children: [{
          value: 'metaData',
          label: 'metaData',
          children: [{
            value: 'layout',
            label: '组件名称'   //组件名称、镜像名称、组件描述、组件版本
          }, {
            value: 'color',
            label: '镜像名称'
          }, {
            value: 'typography',
            label: '组件描述'
          }, {
            value: 'icon',
            label: '组件版本'
          }]
        },{
          value: 'Data',
          label: 'Data',
          children: [{
            value: 'layout',
            label: 'Input'   //输入输出参数、超参数、数据集、环境依赖配置、文件路径
          }, {
            value: 'color',
            label: 'Output'
          }, {
            value: 'typography',
            label: 'Parameter'
          }, {
            value: 'icon',
            label: 'Dataset'
          }, {
            value: 'environment',
            label: 'Environment'
          }, {
            value: 'path',
            label: 'Path'
          }]
        },]
      },{
        value: 'tztq',
        label: '特征提取',
        children: [{
          value: 'metaData',
          label: 'metaData',
          children: [{
            value: 'layout',
            label: '组件名称'   //组件名称、镜像名称、组件描述、组件版本
          }, {
            value: 'color',
            label: '镜像名称'
          }, {
            value: 'typography',
            label: '组件描述'
          }, {
            value: 'icon',
            label: '组件版本'
          }]
        },{
          value: 'Data',
          label: 'Data',
          children: [{
            value: 'layout',
            label: 'Input'   //输入输出参数、超参数、数据集、环境依赖配置、文件路径
          }, {
            value: 'color',
            label: 'Output'
          }, {
            value: 'typography',
            label: 'Parameter'
          }, {
            value: 'icon',
            label: 'Dataset'
          }, {
            value: 'environment',
            label: 'Environment'
          }, {
            value: 'path',
            label: 'Path'
          }]
        },]
      },{
        value: 'sjsc',
        label: '数据输出',
        children: [{
          value: 'metaData',
          label: 'metaData',
          children: [{
            value: 'layout',
            label: '组件名称'   //组件名称、镜像名称、组件描述、组件版本
          }, {
            value: 'color',
            label: '镜像名称'
          }, {
            value: 'typography',
            label: '组件描述'
          }, {
            value: 'icon',
            label: '组件版本'
          }]
        },{
          value: 'Data',
          label: 'Data',
          children: [{
            value: 'layout',
            label: 'Input'   //输入输出参数、超参数、数据集、环境依赖配置、文件路径
          }, {
            value: 'color',
            label: 'Output'
          }, {
            value: 'typography',
            label: 'Parameter'
          }, {
            value: 'icon',
            label: 'Dataset'
          }, {
            value: 'environment',
            label: 'Environment'
          }, {
            value: 'path',
            label: 'Path'
          }]
        },]
      }],
      Svalue: '',
      Nvalue: '',
    }
  },
  methods: {
    // 更新箭头
    handleArrow (e) {
      console.log('e', e)
      console.log('Type of e:', typeof e); // 打印类型
      switch (e) {
        // 正向箭头
        case 1:
          console.log("1111111")
          this.curEdge.setAttrs({
            line: {
              targetMarker: {
                name: 'block',
                width: 12,
                height: 8
              }
            }
          })
          this.curEdge.removeAttrByPath('line/sourceMarker')
          break
        // 逆向箭头
        case 2:
          console.log("2222222")
          this.curEdge.setAttrs({
            line: {
              sourceMarker: {
                name: 'block',
                width: 12,
                height: 8
              }
            }
          })
          this.curEdge.removeAttrByPath('line/targetMarker')
          break
        // 双向箭头
        case 3:
          console.log("3333333")
          this.curEdge.setAttrs({
            line: {
              targetMarker: {
                name: 'block',
                width: 12,
                height: 8
              },
              sourceMarker: {
                name: 'block',
                width: 12,
                height: 8
              }
            }
          })
          break
      }
    },
    // 修改边label属性
    changeEdgeLabel(label, fontColor, fill, stroke){
      this.curEdge.setLabels([configEdgeLabel(label, fontColor, fill, stroke)])
      if(!label) this.labelForm = { fontColor: '#333', fill: '#FFF', stroke: '#555' }
    },
    // 修改边的颜色
    changeEdgeStroke(val){
      // this.curEdge.attr('line/stroke', val)
      console.log('val', val)
      this.curEdge.setAttrs({
        line: {
          stroke: val
        }}
      )
    },
    // 边的样式
    changeEdgeConnector(val){
      switch (val) {
        case 'normal':
          this.curEdge.setConnector(val)
          break;
        case 'smooth':
          this.curEdge.setConnector(val)
          break;
        case 'rounded':
          this.curEdge.setConnector(val, { radius: 20 })
          break;
        case 'jumpover':
          this.curEdge.setConnector(val, { radius: 20 })
          break;
      }
    },
    // 边的宽度
    changeEdgeStrokeWidth(val){
      if(this.lineForm.isArrows){
        this.curEdge.attr({
          line: {
            strokeWidth: val,
            sourceMarker: {
              width: 12 * (val / 2) || 12,
              height: 8 * (val / 2) || 8
            },
            targetMarker: {
              width: 12 * (val / 2) || 12,
              height: 8 * (val / 2) || 8
            }
          }
        })

      } else {
        this.curEdge.attr({
          line: {
            strokeWidth: val,
            targetMarker: {
              width: 12 * (val / 2) || 12,
              height: 8 * (val / 2) || 8
            }
          }
        })
      }

    },
    // 边的箭头
    changeEdgeArrows(val){
      if(val){
        this.curEdge.attr({
          line: {
            sourceMarker: {
              name: 'block',
              width: 12 * (this.lineForm.strokeWidth / 2) || 12,
              height: 8 * (this.lineForm.strokeWidth / 2) || 8
            },
            targetMarker: {
              name: 'block',
              width: 12 * (this.lineForm.strokeWidth / 2) || 12,
              height: 8 * (this.lineForm.strokeWidth / 2) || 8
            },
          }
        })
      } else {
        this.curEdge.attr({
          line: {
            sourceMarker: '',
            targetMarker: {
              name: 'block',
              size: 10 * (this.lineForm.strokeWidth / 2) || 10
            },
          }
        })
      }
    },
    // 边的添加蚂蚁线
    changeEdgeAnit(val){
      if (val) {
        this.curEdge.setAttrs({
          line: {
            strokeDasharray: 5.5
          }}
        )
      } else {
        this.curEdge.removeAttrByPath('line/strokeDasharray')
      }
    },
    // 给线添加调节工具
    changeEdgeTools(val){

        this.changeEdgeConnector('smooth');

        if (val) {
          this.curEdge.addTools(['vertices', 'segments']);
        } else {
          this.curEdge.removeTools();
        }
      },

  },
  watch: {
    edge (newValue) {
      console.log('传过来了edge', newValue)
      this.curEdge = newValue
      this.lineForm.stroke = this.curEdge.attrs.line.stroke
      this.lineForm.isAnit = !!this.curEdge.attrs.line.strokeDasharray
      console.log('this.lineForm.isAnit', this.lineForm.isAnit)
      console.log('this.lineForm.stroke', this.lineForm.stroke)
      console.log('this.curEdge', this.curEdge)
      // this.lineForm.id = this.curEdge.id
      this.curLabel = this.curEdge.labels && this.curEdge.labels.length ? this.curEdge.labels[0].attrs.labelText.text : ''
      this.labelText = this.curLabel
      console.log('curLabel', this.curLabel)
    },
    curEdge (newValue) {
      this.$emit('updateData', newValue)
    }
  }
}
</script>

<style scoped>

</style>
