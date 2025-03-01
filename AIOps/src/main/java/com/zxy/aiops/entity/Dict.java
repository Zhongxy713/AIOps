package com.zxy.aiops.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * <p>
 * 
 * </p>
 *
 * @author 仲翔宇
 * @since 2022-07-17
 */
@Getter
@Setter
  @TableName("sys_dict")
public class Dict implements Serializable {

    private static final long serialVersionUID = 1L;


      private String name;


      private String value;


      private String type;


}
