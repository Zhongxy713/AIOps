package com.zxy.aiops.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.log.Log;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zxy.aiops.common.Constants;
import com.zxy.aiops.controller.dto.UserDTO;
import com.zxy.aiops.controller.dto.UserPasswordDTO;
import com.zxy.aiops.entity.*;
import com.zxy.aiops.exception.ServiceException;

import com.zxy.aiops.mapper.UserMapper;
import com.zxy.aiops.service.*;
import com.zxy.aiops.utils.TokenUtils;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;


import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;


/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author 仲翔宇
 * @since 2022-07-14
 */
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {

    private static final Log LOG = Log.get();
    @Resource
    private IRoleService roleService;

    @Resource
    private IRoleMenuService roleMenuService;

    @Resource
    private IMenuService menuService;
    @Resource
    private UserMapper userMapper;

    public UserDTO login(UserDTO userDTO) {
        User one = getUserInfo(userDTO);
        if (one != null) {
            BeanUtil.copyProperties(one, userDTO, true); //不区分大小写
            //设置Token
            String token = TokenUtils.genToken(one.getId().toString(), one.getPassword());
            userDTO.setToken(token);

            String role = one.getRole(); // ROLE_ADMIN
            //寻找当前权限在数据库对应的id是多少
            QueryWrapper<Role> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("flag",role);
            Integer roleId = roleService.list(queryWrapper).get(0).getId();
            //设置用户的菜单列表
            List<Menu> roleMenus = getRoleMenus(roleId);
            userDTO.setMenus(roleMenus);
            return userDTO;
        } else {
            throw new ServiceException(Constants.CODE_600, "用户名或密码错误");
        }
    }
    @Override
    public User register(UserDTO userDTO) {
        User one = getUserInfo(userDTO);
        if (one == null) {
            one = new User();
            BeanUtil.copyProperties(userDTO, one, true);
            save(one);  // 把 copy完之后的用户对象存储到数据库
        } else {
            throw new ServiceException(Constants.CODE_600, "用户已存在");
        }
        return one;
    }

    @Override
    public void updatePassword(UserPasswordDTO userPasswordDTO) {
        int update = userMapper.updatePassword(userPasswordDTO);
        if (update < 1) {
            throw new ServiceException(Constants.CODE_600, "密码错误");
        }
    }
    @Override
    public Page<User> findPage(Page<User> page, String username, String email, String address) {
        return userMapper.findPage(page, username, email, address);
    }

    private User getUserInfo(UserDTO userDTO) {
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", userDTO.getUsername());
        queryWrapper.eq("password", userDTO.getPassword());
        User one;
        try {
            one = getOne(queryWrapper); // 从数据库查询用户信息
        } catch (Exception e) {
            LOG.error(e);
            throw new ServiceException(Constants.CODE_500, "系统错误");
        }
        return one;
    }

    /**
     * 获取当前角色的菜单列表
     * @param roleId
     * @return
     */
    private List<Menu> getRoleMenus(Integer roleId) {
        //找到当前角色所拥有的菜单id集合 menuIds
        QueryWrapper<RoleMenu> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("role_id",roleId);
        List<RoleMenu> roleMenu = roleMenuService.list(queryWrapper);
        List<Integer> menuIds =  roleMenu.stream().map(RoleMenu::getMenuId).collect(Collectors.toList());
        //查出系统所有的菜单
        List<Menu> menus = menuService.findMenus("");
        // new一个最后筛选完成之后的list
        ArrayList<Menu> roleMenus = new ArrayList<>();
        //筛选当前用户角色的菜单
        for (Menu menu : menus) {
            if (menuIds.contains(menu.getId())) {
                roleMenus.add(menu);
            }
            List<Menu> children = menu.getChildren();
            //removeIf  移除 children 里面不在 menuIds集合中的元素
            children.removeIf(child -> !menuIds.contains(child.getId()));
        }
        return roleMenus;
    }

}
