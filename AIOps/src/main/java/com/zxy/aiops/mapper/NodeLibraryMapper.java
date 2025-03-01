package com.zxy.aiops.mapper;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.zxy.aiops.entity.NodeLibrary;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author 仲翔宇
 * @since 2024-09-25
 */
public interface NodeLibraryMapper extends BaseMapper<NodeLibrary> {

    String getParamValueByParamName(@Param("nodeName") String nodeName, @Param("paramName") String paramName);

    Page<NodeLibrary> getNodeParamList(Page<NodeLibrary> page, @Param("nodeName") String nodeName);



    @Select("SELECT nl.id, nl.node_name, " +
            "JSON_UNQUOTE(JSON_EXTRACT(nl.param_names, CONCAT('$[', idxs.idx - 1, ']'))) AS param_name, " +
            "JSON_UNQUOTE(JSON_EXTRACT(nl.param_values, CONCAT('$[', idxs.idx - 1, ']'))) AS param_value, " +
            "JSON_UNQUOTE(JSON_EXTRACT(nl.param_names_zh, CONCAT('$[', idxs.idx - 1, ']'))) AS param_chinese_name " +
            "FROM node_library nl, " +
            "JSON_TABLE(CONCAT('[', REPEAT('0,', JSON_LENGTH(nl.param_names) - 1), '0]'), '$[*]' COLUMNS(idx FOR ORDINALITY)) AS idxs " +
            "WHERE JSON_UNQUOTE(JSON_EXTRACT(nl.param_names, CONCAT('$[', idxs.idx - 1, ']'))) IS NOT NULL")
    List<Map<String, Object>> getNodeParams();
}
