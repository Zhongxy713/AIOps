package com.zxy.aiops.service.impl;

import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zxy.aiops.entity.Node;
import com.zxy.aiops.entity.NodeData;
import com.zxy.aiops.mapper.NodeMapper;
import com.zxy.aiops.service.INodeService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
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
 * @since 2024-09-18
 */
@Service
public class NodeServiceImpl extends ServiceImpl<NodeMapper, Node> implements INodeService {

    @Resource
    private NodeMapper nodeMapper;
    @Override
    public List<Node> findNodes(String name) {
        QueryWrapper<Node> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByAsc("sort_num");
        if (StrUtil.isNotBlank(name)) {
            queryWrapper.like("node_title", name);
        }
        // 查询所有数据
        List<Node> list = list(queryWrapper);

        // 找出pid为null的一级菜单
        List<Node> parentNodes = list.stream().filter(menu -> menu.getPid() == null).collect(Collectors.toList());
        // 找出一级菜单的子菜单
        for (Node node : parentNodes) {
            // 筛选所有数据中pid=父级id的数据就是二级菜单
            node.setChildren(list.stream().filter(m -> node.getId().equals(m.getPid())).collect(Collectors.toList()));
        }

        // 遍历所有节点，增加属性 t 和 f 当 type 的值为 "condition" 时
        for (Node node : list) {
            if ("condition".equals(node.getType())) {
                node.setT("");
                node.setF("");
            }
        }
        return parentNodes;
    }

    @Override
    public NodeData getNodeData(String name) {
        System.out.println("name = " + name);
        return nodeMapper.getNodeData(name);
    }
}
