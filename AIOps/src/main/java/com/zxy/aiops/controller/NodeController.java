package com.zxy.aiops.controller;


import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.zxy.aiops.common.Result;

import com.zxy.aiops.service.INodeService;
import com.zxy.aiops.entity.Node;

import org.springframework.web.bind.annotation.RestController;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author 仲翔宇
 * @since 2024-09-18
 */
@RestController
@RequestMapping("/node")
public class NodeController {

    @Resource
    private INodeService nodeService;

    // 新增或更新
    @PostMapping
    public Result save(@RequestBody Node node) {
        nodeService.saveOrUpdate(node);
        return Result.success();
        }


    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        nodeService.removeById(id);
        return Result.success();
        }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        nodeService.removeByIds(ids);
        return Result.success();
        }

    @GetMapping
    public Result findAll(@RequestParam(defaultValue = "") String name) {
        return Result.success(nodeService.findNodes(name));
        }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(nodeService.getById(id));
        }

    @GetMapping("/findNodeData")
    public Result findNodeData(@RequestParam String name) {
        return Result.success(nodeService.getNodeData(name));
    }
    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize,
                           @RequestParam(defaultValue = "") String nodeName) {
        QueryWrapper<Node> queryWrapper = new QueryWrapper<>();

        System.out.println("-----------------------------------");
        System.out.println("+");
        System.out.println("+");
        System.out.println("+");
        System.out.println("+");
        System.out.println("nodeName: " + nodeName);
        System.out.println("+");
        System.out.println("+");
        System.out.println("+");
        System.out.println("+");
        System.out.println("-----------------------------------");
        if (!"".equals(nodeName)) {
        queryWrapper.like("node_title", nodeName);
        }
        queryWrapper.orderByAsc("id");
        return Result.success(nodeService.page(new Page<>(pageNum, pageSize), queryWrapper));
        }
}

