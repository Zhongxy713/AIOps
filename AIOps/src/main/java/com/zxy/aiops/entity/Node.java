package com.zxy.aiops.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import java.io.Serializable;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

/**
 * <p>
 * 
 * </p>
 *
 * @author 仲翔宇
 * @since 2024-09-18
 */
@Getter
@Setter
public class Node implements Serializable {

    private static final long serialVersionUID = 1L;


        @TableId(value = "id", type = IdType.AUTO)
      private Integer id;


      private String nodeName;


      private String nodeData;


      private Integer nodeInput;


      private Integer nodeOutput;


      private Long userId;


      private String nodeContent;


      private String nodeTitle;


      private Integer pid;


      private Integer sortNum;


      private String img;

    private String type;

    @TableField(exist = false)
    private String f;

    @TableField(exist = false)
    private String t;

    @TableField(exist = false)
    private List<Node> children;

}
