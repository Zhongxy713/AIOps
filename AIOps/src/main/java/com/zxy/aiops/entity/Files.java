package com.zxy.aiops.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
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
 * @since 2022-07-16
 */
@Getter
@Setter
  @TableName("sys_file")
public class Files implements Serializable {

    private static final long serialVersionUID = 1L;

        @TableId(value = "id", type = IdType.AUTO)
      private Integer id;

      private String name;

      private String type;


      private Long size;


      private String url;


      private String md5;


      private Boolean isDelete;


      private Boolean enable;


}
