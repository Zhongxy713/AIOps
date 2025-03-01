package com.zxy.aiops.service.impl;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.zxy.aiops.entity.AlgorithmicPipelineModels;
import com.zxy.aiops.mapper.AlgorithmicPipelineModelsMapper;
import com.zxy.aiops.service.IAlgorithmicPipelineModelsService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author 仲翔宇
 * @since 2024-10-09
 */
@Service
public class AlgorithmicPipelineModelsServiceImpl extends ServiceImpl<AlgorithmicPipelineModelsMapper, AlgorithmicPipelineModels> implements IAlgorithmicPipelineModelsService {


    @Resource
    private AlgorithmicPipelineModelsMapper algorithmicPipelineModelsMapper;
    @Override
    public Page<AlgorithmicPipelineModels> getAPMList(Page<AlgorithmicPipelineModels> page, String apmName) {
        return algorithmicPipelineModelsMapper.getAPMList(page, apmName);
    }
    @Override
    public AlgorithmicPipelineModels getAPMJson(Integer apmId) {
        return algorithmicPipelineModelsMapper.getAPMJson(apmId);
    }
}
