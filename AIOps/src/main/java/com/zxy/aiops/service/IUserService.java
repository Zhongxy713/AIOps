package com.zxy.aiops.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.zxy.aiops.controller.dto.UserDTO;
import com.zxy.aiops.controller.dto.UserPasswordDTO;
import com.zxy.aiops.entity.User;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author 仲翔宇
 * @since 2022-07-14
 */
public interface IUserService extends IService<User> {

    UserDTO login(UserDTO userDTO);

    User register(UserDTO userDTO);

    void updatePassword(UserPasswordDTO userPasswordDTO);
    Page<User> findPage(Page<User> page, String username, String email, String address);
}
