package com.zxy.aiops.controller;


import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.web.bind.annotation.*;
import jakarta.annotation.Resource;
import java.util.List;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zxy.aiops.common.Result;

import com.zxy.aiops.service.IAlgorithmicPipelineModelsService;
import com.zxy.aiops.entity.AlgorithmicPipelineModels;

import org.springframework.web.bind.annotation.RestController;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author 仲翔宇
 * @since 2024-10-09
 */
@RestController
@RequestMapping("/algorithmic-pipeline-models")
public class AlgorithmicPipelineModelsController {

    @Resource
    private IAlgorithmicPipelineModelsService algorithmicPipelineModelsService;

    // 新增或更新
    @PostMapping
    public Result save(@RequestBody AlgorithmicPipelineModels algorithmicPipelineModels) {
        algorithmicPipelineModelsService.saveOrUpdate(algorithmicPipelineModels);
        return Result.success();
        }


    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        algorithmicPipelineModelsService.removeById(id);
        return Result.success();
        }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        algorithmicPipelineModelsService.removeByIds(ids);
        return Result.success();
        }

    @GetMapping
    public Result findAll() {
        return Result.success(algorithmicPipelineModelsService.list());
        }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(algorithmicPipelineModelsService.getById(id));
    }

    @GetMapping("/getAPMJson/{apmId}")
    public Result getAPMJson(@PathVariable Integer apmId) {
        return Result.success(algorithmicPipelineModelsService.getAPMJson(apmId));
    }
    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(defaultValue = "") String apmName) {
//        QueryWrapper<AlgorithmicPipelineModels> queryWrapper = new QueryWrapper<>();
//        if (!"".equals(apmName)) {
//        queryWrapper.like("apm_name", apmName);
//        }
//        queryWrapper.orderByAsc("id");
        return Result.success(algorithmicPipelineModelsService.getAPMList(new Page<>(pageNum, pageSize), apmName));
        }
}

