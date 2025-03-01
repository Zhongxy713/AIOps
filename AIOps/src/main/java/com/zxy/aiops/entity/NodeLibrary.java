package com.zxy.aiops.entity;


import com.alibaba.fastjson.JSONArray;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;

import com.baomidou.mybatisplus.extension.handlers.FastjsonTypeHandler;
import lombok.Getter;
import lombok.Setter;

/**
 * <p>
 * 
 * </p>
 *
 * @author 仲翔宇
 * @since 2024-09-25
 */
@Getter
@Setter
@TableName("node_library")
public class NodeLibrary implements Serializable {

    private static final long serialVersionUID = 1L;

      @TableId(value = "id", type = IdType.AUTO)
      private Integer id;

    private String nodeName;

    private Integer paramCount;

    // 自定义类型处理器，表示java类型与数据库类型双向转换
    @TableField(typeHandler = FastjsonTypeHandler.class)
    private JSONArray paramNames;

    @TableField(typeHandler = FastjsonTypeHandler.class)
    private JSONArray  paramValues;

    @TableField(typeHandler = FastjsonTypeHandler.class)
    private JSONArray  paramNamesZh;


}
