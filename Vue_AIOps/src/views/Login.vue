<template>
  <div class="wrapper">
    <div class="login-container">
      <div class="login-header">
        <div class="logo">
          <i class="el-icon-cpu"></i>
          <span>算法管道模型建模与部署平台</span>
        </div>
        <div class="title">欢迎登录</div>
      </div>

      <el-form :model="user" :rules="rules" ref="userForm" class="login-form">
        <el-form-item prop="username">
          <el-input
              size="medium"
              prefix-icon="el-icon-user"
              v-model="user.username"
              placeholder="请输入用户名"
              class="input-with-icon"
          ></el-input>
        </el-form-item>

        <el-form-item prop="password">
          <el-input
              size="medium"
              prefix-icon="el-icon-lock"
              show-password
              v-model="user.password"
              @change="login"
              placeholder="请输入密码"
              class="input-with-icon"
          ></el-input>
        </el-form-item>

        <el-form-item class="role-selector">
          <el-radio-group v-model="role">
            <el-radio-button label="1">管理员</el-radio-button>
            <el-radio-button label="2">普通用户</el-radio-button>
          </el-radio-group>
        </el-form-item>

        <el-form-item class="login-btn-group">
          <el-button
              type="primary"
              size="medium"
              autocomplete="off"
              @click="login"
              class="login-btn"
          >登 录</el-button>
          <el-button
              type="text"
              size="medium"
              autocomplete="off"
              @click="$router.push('/register')"
              class="register-btn"
          >注册账号</el-button>
        </el-form-item>
      </el-form>

      <div class="footer">
        <div class="tech-lines"></div>
        <div class="copyright">© 2025 算法管道模型建模与部署平台 版权所有</div>
      </div>
    </div>

    <div class="particles" id="particles-js"></div>
  </div>
</template>

<script>
import {setRoutes} from "@/router";
import "particles.js";

export default {
  // eslint-disable-next-line vue/multi-word-component-names
  name: "Login",
  data() {
    return {
      role: '1',
      user: {
        username: 'admin',
        password: 'admin'
      },
      rules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 3, max: 10, message: '长度在 3 到 10 个字符', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 1, max: 20, message: '长度在 1 到 20 个字符', trigger: 'blur' }
        ],
      }
    }
  },
  mounted() {
    this.initParticles();
  },
  methods: {
    initParticles() {
      // eslint-disable-next-line no-undef
      particlesJS("particles-js", {
        "particles": {
          "number": {
            "value": 80,
            "density": {
              "enable": true,
              "value_area": 800
            }
          },
          "color": {
            "value": "#64ffda"
          },
          "shape": {
            "type": "circle",
            "stroke": {
              "width": 0,
              "color": "#000000"
            },
            "polygon": {
              "nb_sides": 5
            }
          },
          "opacity": {
            "value": 0.5,
            "random": false,
            "anim": {
              "enable": false,
              "speed": 1,
              "opacity_min": 0.1,
              "sync": false
            }
          },
          "size": {
            "value": 3,
            "random": true,
            "anim": {
              "enable": false,
              "speed": 40,
              "size_min": 0.1,
              "sync": false
            }
          },
          "line_linked": {
            "enable": true,
            "distance": 150,
            "color": "#64ffda",
            "opacity": 0.4,
            "width": 1
          },
          "move": {
            "enable": true,
            "speed": 2,
            "direction": "none",
            "random": false,
            "straight": false,
            "out_mode": "out",
            "bounce": false,
            "attract": {
              "enable": false,
              "rotateX": 600,
              "rotateY": 1200
            }
          }
        },
        "interactivity": {
          "detect_on": "canvas",
          "events": {
            "onhover": {
              "enable": true,
              "mode": "grab"
            },
            "onclick": {
              "enable": true,
              "mode": "push"
            },
            "resize": true
          },
          "modes": {
            "grab": {
              "distance": 140,
              "line_linked": {
                "opacity": 1
              }
            },
            "bubble": {
              "distance": 400,
              "size": 40,
              "duration": 2,
              "opacity": 8,
              "speed": 3
            },
            "repulse": {
              "distance": 200,
              "duration": 0.4
            },
            "push": {
              "particles_nb": 4
            },
            "remove": {
              "particles_nb": 2
            }
          }
        },
        "retina_detect": true
      });
    },
    login() {
      this.$refs['userForm'].validate((valid) => {
        if (valid) {
          this.request.post("/user/login", this.user).then(res => {
            if(res.code === '200') {
              sessionStorage.setItem("user", JSON.stringify(res.data))
              sessionStorage.setItem("menus", JSON.stringify(res.data.menus))
              setRoutes()
              if (this.role === '1')
                this.$router.push("/back")
              else
                this.$router.push("/")
              this.$message.success("登录成功")
            } else {
              this.$message.error(res.msg)
            }
          })
        }
      });
    }
  }
}
</script>

<style scoped>
.wrapper {
  height: 100vh;
  background: linear-gradient(135deg, #0f2027 0%, #203a43 50%, #2c5364 100%);
  overflow: hidden;
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
  font-family: 'Arial', 'Microsoft YaHei', sans-serif;
}

.login-container {
  width: 400px;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  padding: 40px;
  z-index: 10;
  position: relative;
  backdrop-filter: blur(5px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  animation: fadeIn 0.8s ease-out;
}

.login-header {
  text-align: center;
  margin-bottom: 30px;
}

.logo {
  display: flex;
  align-items: center;
  justify-content: center;
  color: #303133;
  margin-bottom: 15px;
}

.logo i {
  font-size: 28px;
  color: #409EFF;
  margin-right: 10px;
}

.logo span {
  font-size: 20px;
  font-weight: bold;
  letter-spacing: 1px;
}

.title {
  font-size: 24px;
  color: #303133;
  font-weight: 500;
  margin-bottom: 5px;
}

.login-form {
  margin-top: 20px;
}

.input-with-icon >>> .el-input__inner {
  padding-left: 40px !important;
  height: 44px;
  line-height: 44px;
  border-radius: 6px;
  border: 1px solid #dcdfe6;
  transition: all 0.3s;
}

.input-with-icon >>> .el-input__prefix {
  left: 10px;
  display: flex;
  align-items: center;
}

.input-with-icon >>> .el-input__inner:focus {
  border-color: #409EFF;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.role-selector {
  margin: 20px 0;
}

.role-selector >>> .el-radio-button__inner {
  padding: 10px 20px;
  transition: all 0.3s;
}

.login-btn-group {
  margin-top: 30px;
}

.login-btn {
  width: 100%;
  height: 44px;
  font-size: 16px;
  letter-spacing: 2px;
  background: linear-gradient(90deg, #409EFF, #64B5F6);
  border: none;
  border-radius: 6px;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
  transition: all 0.3s;
}

.login-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(64, 158, 255, 0.4);
}

.register-btn {
  width: 100%;
  margin-top: 15px;
  color: #909399;
  transition: all 0.3s;
}

.register-btn:hover {
  color: #409EFF;
}

.footer {
  margin-top: 30px;
  text-align: center;
}

.tech-lines {
  height: 1px;
  background: linear-gradient(90deg, transparent, #dcdfe6, transparent);
  margin-bottom: 20px;
}

.copyright {
  font-size: 12px;
  color: #909399;
}

.particles {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes pulse {
  0% {
    opacity: 0.8;
  }
  100% {
    opacity: 1;
  }
}
</style>
