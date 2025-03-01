package com.zxy.aiops.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * <p>
 * 
 * </p>
 *
 * @author 仲翔宇
 * @since 2022-07-14
 */
@Getter
@Setter
@TableName("sys_user")
public class User implements Serializable {

    private static final long serialVersionUID = 1L;


        @TableId(value = "id", type = IdType.AUTO)
      private Integer id;


      private String username;


      private String password;


      private String nickname;


      private String email;


      private String phone;


      private String address;


      private Date createTime;


      private String avatarUrl;


      private String role;

}
