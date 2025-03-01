package com.zxy.aiops.service;

import com.zxy.aiops.entity.Node;
import com.baomidou.mybatisplus.extension.service.IService;
import com.zxy.aiops.entity.NodeData;

import java.util.List;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author 仲翔宇
 * @since 2024-09-18
 */
public interface INodeService extends IService<Node> {

    List<Node> findNodes(String name);

    NodeData getNodeData(String name);
}
