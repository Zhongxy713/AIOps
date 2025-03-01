package com.zxy.aiops.mapper;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.zxy.aiops.entity.AlgorithmicPipelineModels;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.zxy.aiops.entity.NodeLibrary;
import org.apache.ibatis.annotations.Param;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author 仲翔宇
 * @since 2024-10-09
 */
public interface AlgorithmicPipelineModelsMapper extends BaseMapper<AlgorithmicPipelineModels> {

    Page<AlgorithmicPipelineModels> getAPMList(Page<AlgorithmicPipelineModels> page, @Param("apmName") String apmName);

    AlgorithmicPipelineModels getAPMJson(@Param("apmId") Integer apmId);
}
