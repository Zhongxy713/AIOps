package com.zxy.aiops.controller;


import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.zxy.aiops.common.Result;
import com.zxy.aiops.entity.Dict;
import com.zxy.aiops.service.IDictService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author 仲翔宇
 * @since 2022-07-17
 */
@RestController
@RequestMapping("/dict")
public class DictController {

    @Resource
    private IDictService dictService;

    // 新增或更新
    @PostMapping
    public Result save(@RequestBody Dict dict) {
        dictService.saveOrUpdate(dict);
        return Result.success();
        }


    @DeleteMapping("/{id}")
    public Result delete(@PathVariable Integer id) {
        dictService.removeById(id);
        return Result.success();
        }

    @PostMapping("/del/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        dictService.removeByIds(ids);
        return Result.success();
        }

    @GetMapping
    public Result findAll() {
        return Result.success(dictService.list());
        }

    @GetMapping("/{id}")
    public Result findOne(@PathVariable Integer id) {
        return Result.success(dictService.getById(id));
        }

    @GetMapping("/page")
    public Result findPage(@RequestParam Integer pageNum,
                           @RequestParam Integer pageSize) {
        QueryWrapper<Dict> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByAsc("id");
        return Result.success(dictService.page(new Page<>(pageNum, pageSize), queryWrapper));
        }
}

