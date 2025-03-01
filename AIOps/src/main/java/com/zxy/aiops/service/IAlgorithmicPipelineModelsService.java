package com.zxy.aiops.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.zxy.aiops.entity.AlgorithmicPipelineModels;
import com.baomidou.mybatisplus.extension.service.IService;
import com.zxy.aiops.mapper.AlgorithmicPipelineModelsMapper;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author 仲翔宇
 * @since 2024-10-09
 */
public interface IAlgorithmicPipelineModelsService extends IService<AlgorithmicPipelineModels> {

    Page<AlgorithmicPipelineModels> getAPMList(Page<AlgorithmicPipelineModels> page, String apmName);

    AlgorithmicPipelineModels getAPMJson(Integer apmId);
}
