package com.zxy.aiops.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zxy.aiops.entity.Role;
import com.zxy.aiops.entity.RoleMenu;
import com.zxy.aiops.mapper.RoleMapper;
import com.zxy.aiops.service.IRoleMenuService;
import com.zxy.aiops.service.IRoleService;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author 仲翔宇
 * @since 2022-07-17
 */
@Service
public class RoleServiceImpl extends ServiceImpl<RoleMapper, Role> implements IRoleService {

    @Resource
    private IRoleMenuService roleMenuService;
    @Override
    public void setRoleMenu(Integer roleId, List<Integer> menuIds) {
        //先删除当前角色所有的绑定关系
        roleMenuService.removeById(roleId);

        //再把前端传过来的绑定菜单ID数组绑定到当前的这个角色ID上去

        for(Integer menuID : menuIds) {
            RoleMenu roleMenu = new RoleMenu();
            roleMenu.setRoleId(roleId);
            roleMenu.setMenuId(menuID);
            roleMenuService.save(roleMenu);
        }
    }

    @Override
    public List<Integer> getRoleMenu(Integer roleId) {

        QueryWrapper<RoleMenu> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("role_id",roleId);
        List<RoleMenu> roleMenus = roleMenuService.list(queryWrapper);
        List<Integer> menus =  roleMenus.stream().map(RoleMenu::getMenuId).collect(Collectors.toList());
        return menus;
    }
}
