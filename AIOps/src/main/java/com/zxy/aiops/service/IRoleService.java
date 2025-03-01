package com.zxy.aiops.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.zxy.aiops.entity.Role;

import java.util.List;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author 仲翔宇
 * @since 2022-07-17
 */
public interface IRoleService extends IService<Role> {

    void setRoleMenu(Integer roleId, List<Integer> menuIds);

    public List<Integer> getRoleMenu(Integer roleId);

}
