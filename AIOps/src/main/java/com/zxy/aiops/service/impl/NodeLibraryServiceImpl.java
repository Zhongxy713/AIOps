package com.zxy.aiops.service.impl;



import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.zxy.aiops.entity.NodeLibrary;
import com.zxy.aiops.mapper.NodeLibraryMapper;
import com.zxy.aiops.service.INodeLibraryService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author 仲翔宇
 * @since 2024-09-25
 */
@Service
public class NodeLibraryServiceImpl extends ServiceImpl<NodeLibraryMapper, NodeLibrary> implements INodeLibraryService {

    @Resource
    private NodeLibraryMapper nodeLibraryMapper;


    @Override
    public String getParamValue(String nodeName, String paramName) {
        return nodeLibraryMapper.getParamValueByParamName(nodeName, paramName);
    }

    @Override
    public Page<NodeLibrary> getNodeParamList(Page<NodeLibrary> page, String nodeName) {
        return nodeLibraryMapper.getNodeParamList(page, nodeName);
    }

    @Override
    public List<Map<String, Object>> getNodeData() {
        List<Map<String, Object>> results = nodeLibraryMapper.getNodeParams();

        // 创建一个 Map 来存储节点数据
        Map<Integer, Map<String, Object>> nodeDataMap = new LinkedHashMap<>();

        for (Map<String, Object> row : results) {
            Integer id = (Integer) row.get("id");
            String nodeName = (String) row.get("node_name");
            String paramName = (String) row.get("param_name");
            String paramValue = (String) row.get("param_value");
            String paramChineseName = (String) row.get("param_chinese_name");

            // 如果该节点不存在，先创建
            nodeDataMap.putIfAbsent(id, new HashMap<String, Object>() {{
                put("id", id);
                put("nodeName", nodeName);
                put("paramNames", new ArrayList<Map<String, String>>());
            }});

            // 向 paramNames 中添加参数名和对应的值
            List<Map<String, String>> paramNames = (List<Map<String, String>>) nodeDataMap.get(id).get("paramNames");
            paramNames.add(new HashMap<String, String>() {{
                put("paramNameZh", paramChineseName);
                put("paramName", paramName);
                put("paramValue", paramValue);
            }});
        }

        return new ArrayList<>(nodeDataMap.values());
    }
}
