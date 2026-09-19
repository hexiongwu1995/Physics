// 绘制电场线，模拟两个点电荷在空间产生的电场

import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";
import { constants } from "fundamental-physical-constants";
import { GUI } from "three/addons/libs/lil-gui.module.min.js";
import { setCanvasSize, setGUIinWrapper, onResize } from "./three/setting.js";
import { createLine } from "./three/utils.js";

// =====================================================

const canvasWrapper = document.querySelector("#fibonacci-sampling-wrapper");
const canvas = document.querySelector("#fibonacci-sampling-canvas");

setCanvasSize(canvas);
const canvasWidth = canvas.width;
const canvasHeight = canvas.height;

const scene = new THREE.Scene();

const camera = new THREE.PerspectiveCamera(75, canvasWidth / canvasHeight, 0.01, 100);
scene.add(camera);
camera.position.set(0.5, 0.5, 0.5);
camera.lookAt(0, 0, 0);

const ambientLight = new THREE.AmbientLight(0xffffff, 0.2);
scene.add(ambientLight);

const pointLight = new THREE.PointLight(0xffffff, 1.0, 10);
scene.add(pointLight);
pointLight.position.copy(camera.position);

const renderer = new THREE.WebGLRenderer({ canvas, antialias: true });
renderer.setClearColor(0xfafafa, 1);
renderer.setSize(canvasWidth, canvasHeight, false);
renderer.render(scene, camera);

const orbitControl = new OrbitControls(camera, canvas);
orbitControl.target.set(0, 0, 0);
orbitControl.enablePan = false;
orbitControl.update();

const gui = new GUI({ container: canvasWrapper });
setGUIinWrapper(gui, canvasWrapper, orbitControl);

// =====================================================

// const axesHelper = new THREE.AxesHelper(0.12);
// scene.add(axesHelper);

// const gridHelper = new THREE.GridHelper(0.2, 10);
// scene.add(gridHelper);

const particle1 = new THREE.Mesh(new THREE.SphereGeometry(0.3, 32, 32), new THREE.MeshStandardMaterial({ color: 0xee5555, opacity: 0.7, transparent: true }));
particle1.position.set(0, 0, 0);
scene.add(particle1);

const sphereRadius = particle1.geometry.parameters.radius;

const axis = new THREE.AxesHelper(0.5);
axis.position.set(0, 0, 0);
scene.add(axis);

// const y = 0;
// const radius = Math.sqrt(1 - y * y);
// const phi = (1 + Math.sqrt(5)) / 2;
// const theta = (2 * Math.PI * 1) / phi; // 黄金角度增量
// // const theta = Math.PI / 10; // 黄金角度增量
// const z = Math.cos(theta) * radius;
// const x = Math.sin(theta) * radius;
// const point = new THREE.Vector3(x, y, z).multiplyScalar(sphereRadius);
// const largeDot = new THREE.Mesh(new THREE.SphereGeometry(0.01, 10, 10), new THREE.MeshStandardMaterial({ color: 0x5555ff, opacity: 0.8, transparent: true }));
// largeDot.position.copy(point);
// scene.add(largeDot);

function getFibonacciSpherePoints(N) {
  const surfacePoints = [];
  const phi = (1 + Math.sqrt(5)) / 2;

  for (let i = 0; i < N; i++) {
    const y = (N - 1 - 2 * i) / (N - 1);
    const radius = Math.sqrt(1 - y * y);
    const theta = (2 * Math.PI * i) / phi;
    const z = radius * Math.cos(theta);
    const x = radius * Math.sin(theta);
    surfacePoints.push(new THREE.Vector3(x, y, z));
  }
  return surfacePoints;
}

const surfacePoints = getFibonacciSpherePoints(100).map((point) => point.multiplyScalar(sphereRadius));
surfacePoints.forEach((point) => {
  //   const line = createLine(new THREE.Vector3(0, 0, 0), point);
  //   scene.add(line);
  const dot = new THREE.Mesh(new THREE.SphereGeometry(0.005, 10, 10), new THREE.MeshStandardMaterial({ color: 0x55ff55, opacity: 0.8, transparent: true }));
  dot.position.copy(point);
  scene.add(dot);
});

// =====================================================

//  setAnimationInfo()
const targetFPS = 10;
const frameInterval = 1000 / targetFPS;
let lastFrameTime = 0;
let animationId = null;
let isVisible = false;

function animate(currentTime) {
  animationId = requestAnimationFrame(animate);

  const deltaTime = currentTime - lastFrameTime;
  if (deltaTime < frameInterval) return;

  lastFrameTime = currentTime - (deltaTime % frameInterval);
  // 将 lastFrameTime 对齐到理论帧时间点（frameInterval的整数倍）
  // 避免因帧率波动导致的渲染时间点漂移
  // 效果：长期保持平均 targetFPS，避免误差累积

  orbitControl.update();
  pointLight.position.copy(camera.position);
  renderer.render(scene, camera);
}

// 方案一：在每个独立的动画文件中使用 Intersection Observer 监听可见性
const observer = new IntersectionObserver(
  (entries) => {
    // const entry = entries[0];
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        // 元素进入可视区域，恢复动画
        if (!isVisible) {
          // 只有之前不可见时才恢复
          isVisible = true;
          lastFrameTime = performance.now(); // 重置时间，避免跳帧
          animationId = requestAnimationFrame(animate);
        }
      } else {
        // 元素离开可视区域，停止动画
        if (isVisible) {
          // 只有之前可见时才停止
          isVisible = false;
          if (animationId !== null) {
            cancelAnimationFrame(animationId);
            animationId = null;
          }
        }
      }
    });
  },
  {
    root: null, // 默认为视口
    rootMargin: "1px", // 表示视口外1px触发可见
    threshold: 0, // 观察的阈值
    // 阈值为0表示当元素开始进入视口时触发可见，当元素完全离开视口时触发不可见
    // 开始进入视口时运行一次回调函数，完全离开视口时再运行一次回调函数，中间过程不运行回调函数
  },
);
// 开始观察 canvasWrapper
observer.observe(canvasWrapper);

window.addEventListener("resize", () => {
  onResize(canvas, camera, renderer);
});

document.addEventListener("fullscreenchange", () => {
  setTimeout(() => onResize(canvas, camera, renderer), 100);
});
