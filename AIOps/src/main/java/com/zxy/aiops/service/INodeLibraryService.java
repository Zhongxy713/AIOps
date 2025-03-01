package com.zxy.aiops.service;

import cn.hutool.json.JSONException;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.zxy.aiops.entity.NodeLibrary;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;
import java.util.Map;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author 仲翔宇
 * @since 2024-09-25
 */
public interface INodeLibraryService extends IService<NodeLibrary> {

    public String getParamValue(String nodeName, String paramName);
    Page<NodeLibrary> getNodeParamList(Page<NodeLibrary> page, String nodeName);

    List<Map<String, Object>> getNodeData();

}
