package com.zxy.aiops.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import lombok.Getter;
import lombok.Setter;
import com.baomidou.mybatisplus.extension.handlers.FastjsonTypeHandler;
import com.alibaba.fastjson.JSONArray;
/**
 * <p>
 * 
 * </p>
 *
 * @author 仲翔宇
 * @since 2024-10-09
 */
@Getter
@Setter
  @TableName("algorithmic_pipeline_models")
public class AlgorithmicPipelineModels implements Serializable {

    private static final long serialVersionUID = 1L;

      /**
     * id
     */
        @TableId(value = "id", type = IdType.AUTO)
      private Integer id;

      /**
     * 算法管道模型名称
     */
      private String apmName;

      /**
     * 创建者
     */
      private String createAuthor;

      /**
     * 描述
     */
      private String description;

      /**
     * 组件id序列
     */

      // 自定义类型处理器，表示java类型与数据库类型双向转换
      @TableField(typeHandler = FastjsonTypeHandler.class)
      private JSONArray nodeList;

      /**
     * 组件名称集合
     */
      // 自定义类型处理器，表示java类型与数据库类型双向转换
      @TableField(typeHandler = FastjsonTypeHandler.class)
      private JSONArray nodeNameList;

      /**
     * 规则集合
     */
      // 自定义类型处理器，表示java类型与数据库类型双向转换
      @TableField(typeHandler = FastjsonTypeHandler.class)
      private JSONArray ruleList;


      /**
       * 边集合
       */
      // 自定义类型处理器，表示java类型与数据库类型双向转换
      @TableField(typeHandler = FastjsonTypeHandler.class)
      private JSONArray edgeList;

      /**
       * 算法管道模型JSON
       */
      // 自定义类型处理器，表示java类型与数据库类型双向转换
      private String apmJson;

}
