package com.zxy.aiops.controller;


import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.zxy.aiops.entity.User;
import jakarta.annotation.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.Map;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zxy.aiops.common.Result;

import com.zxy.aiops.service.INodeLibraryService;
import com.zxy.aiops.entity.NodeLibrary;

import org.springframework.web.bind.annotation.RestController;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author 仲翔宇
 * @since 2024-09-25
 */
@RestController
@RequestMapping("/nodeLibrary")
public class NodeLibraryController {

    @Resource
    private INodeLibraryService nodeLibraryService;

    // 新增或更新
    @PostMapping
    public Result save(@RequestBody NodeLibrary nodeLibrary) {
        nodeLibraryService.saveOrUpdate(nodeLibrary);
        return Result.success();
        }


    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        nodeLibraryService.removeById(id);
        return Result.success();
        }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        nodeLibraryService.removeByIds(ids);
        return Result.success();
        }

    @GetMapping
    public Result findAll() {
        return Result.success(nodeLibraryService.list());
        }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(nodeLibraryService.getById(id));
        }

    @GetMapping("/findBynodeName")
    public Result findBynodeName(@RequestParam String nodeName, @RequestParam String paramName) {
        return Result.success(nodeLibraryService.getParamValue(nodeName, paramName));
    }

    @GetMapping("/getAllNodes")
    public Result getAllNodes() {
        List<Map<String, Object>> nodeData = nodeLibraryService.getNodeData();
        return Result.success(nodeData);
    }

    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(defaultValue = "") String name) {
//        QueryWrapper<NodeLibrary> queryWrapper = new QueryWrapper<>();
//        if (!"".equals(name)) {
//        queryWrapper.like("name", name);
//        }
//        queryWrapper.orderByAsc("id");
        return Result.success(nodeLibraryService.getNodeParamList(new Page<>(pageNum, pageSize), name));
        }
}

