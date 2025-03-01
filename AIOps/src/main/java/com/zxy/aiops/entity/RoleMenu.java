package com.zxy.aiops.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

/**
 * <p>
 * 角色菜单关系表
 * </p>
 *
 * @author 仲翔宇
 * @since 2022-07-18
 */
@Getter
@Setter
  @TableName("sys_role_menu")

public class RoleMenu implements Serializable {

    private static final long serialVersionUID = 1L;


      @TableId(type = IdType.AUTO)
        private Integer roleId;


        private Integer menuId;


}
