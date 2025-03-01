package com.zxy.aiops.entity;

import lombok.Data;

@Data
public class NodeData {

    // 组件id
    private Integer Id;

    // 组件名称
    private String nodeName;

    // 组件描述
    private String nodeDescription;

    // 组件版本
    private String nodeVersion;

    // 组件依赖
    private String nodeDependence;


}
