package com.zxy.aiops.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.zxy.aiops.entity.Role;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author 仲翔宇
 * @since 2022-07-17
 */
public interface RoleMapper extends BaseMapper<Role> {
//@Select("select id from sys_role where flag = #{flag}")
//    Integer selectByFlag(String role);
}
