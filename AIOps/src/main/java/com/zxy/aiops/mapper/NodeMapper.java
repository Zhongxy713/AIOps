package com.zxy.aiops.mapper;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.zxy.aiops.entity.Node;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.zxy.aiops.entity.NodeData;
import org.apache.ibatis.annotations.Param;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author 仲翔宇
 * @since 2024-09-18
 */
public interface NodeMapper extends BaseMapper<Node> {

    Page<Node> findPage();
    NodeData getNodeData(@Param("name") String name);
}
