// 绘制电场线，模拟两个点电荷在空间产生的电场

import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";
import { constants } from "fundamental-physical-constants";
import { GUI } from "three/addons/libs/lil-gui.module.min.js";
import { setGUIinWrapper, onResize } from "./three/setting.js";

const dpr = window.devicePixelRatio;
const canvasWrapper = document.querySelector("#electric-field-wrapper");
const canvas = document.querySelector("#electric-field-canvas");
const textElement = document.querySelector("#electric-field-text");
canvas.width = canvas.clientWidth * dpr;
canvas.height = canvas.clientHeight * dpr;
const canvasWidth = canvas.width;
const canvasHeight = canvas.height;

const scene = new THREE.Scene();

// const axesHelper = new THREE.AxesHelper(0.12);
// scene.add(axesHelper);

// const gridHelper = new THREE.GridHelper(0.2, 10);
// scene.add(gridHelper);

const particle1 = new THREE.Mesh(new THREE.SphereGeometry(0.003, 16, 16), new THREE.MeshBasicMaterial({ color: 0xaaaaaa, opacity: 0.5, transparent: true }));
particle1.position.set(0, 0, 0);
scene.add(particle1);

const particle2 = new THREE.Mesh(new THREE.SphereGeometry(0.003, 16, 16), new THREE.MeshBasicMaterial({ color: 0x00ff00 }));
particle2.position.set(0.06, 0, 0);
scene.add(particle2);

const vacuumElectricPermittivity = constants["vacuum electric permittivity"].value;

const k = 1 / (4 * Math.PI * vacuumElectricPermittivity);
const particle1Charge = 4.0e-8;
const particle2Charge = -1.0e-8;
const distance = 0.06;

const electricForce = (k * particle1Charge * particle2Charge) / distance ** 2;

textElement.innerHTML = `静电力常数： ${k.toExponential(2)} N m^2 / C^2 <br> 两个电荷之间的静电力： ${electricForce.toExponential(2)} N `;

// 生成球面采样点
let surfacePoints = [];
function generateSurfacePoints(particle, options = {}) {
  const { stepNum = 10 } = options;
  const radius = particle.geometry.parameters.radius;
  for (let i = 0; i < stepNum; i++) {
    for (let j = 0; j < stepNum; j++) {
      let phi = (i * Math.PI) / stepNum;
      let theta = (j * 2 * Math.PI) / stepNum;
      const surfacePoint = new THREE.Vector3();
      surfacePoint.setFromSphericalCoords(radius, phi, theta);
      surfacePoints.push(surfacePoint);
    }
  }
}

generateSurfacePoints(particle1, { stepNum: 10 });

// textElement.innerHTML += `<br>球面采样点数量：${surfacePoints.length}`;

console.log(surfacePoints);
console.log(particle1.position);

for (let i = 0; i < surfacePoints.length; i++) {
  const line = new THREE.Line(new THREE.BufferGeometry().setFromPoints([particle1.position.clone(), surfacePoints[i].clone()]), new THREE.LineBasicMaterial({ color: 0xff0000 }));
  scene.add(line);
}

function getSpaceElectricField(point) {
  const field = new THREE.Vector3();
  // 来自particle1的电场
  const distance1 = point.distanceTo(particle1.position);
  const filed1 = point
    .clone()
    .sub(particle1.position)
    .normalize()
    .multiplyScalar((k * particle1Charge) / distance1 ** 2);
  field.add(filed1);
  // 来自particle2的电场
  const distance2 = point.distanceTo(particle2.position);
  const filed2 = point
    .clone()
    .sub(particle2.position)
    .normalize()
    .multiplyScalar((k * particle2Charge) / distance2 ** 2);
  field.add(filed2);
  return field;
}

function traceFieldLineFromSurface(stepLength, maxStepLength) {
  for (let i = 0; i < surfacePoints.length; i++) {
    let startPoint = surfacePoints[i].clone();
    let direction = getSpaceElectricField(startPoint).normalize();
    let currentPoint = startPoint.clone().add(direction.multiplyScalar(stepLength));
    while (currentPoint.distanceTo(particle1.position) <= maxStepLength && currentPoint.distanceTo(particle2.position) >= particle2.geometry.parameters.radius) {
      const line = new THREE.Line(new THREE.BufferGeometry().setFromPoints([startPoint.clone(), currentPoint.clone()]), new THREE.LineBasicMaterial({ color: 0x00ff00 }));
      scene.add(line);
      startPoint = currentPoint.clone();
      direction = getSpaceElectricField(startPoint).normalize();
      currentPoint = currentPoint.clone().add(direction.multiplyScalar(stepLength));
    }
  }
}

traceFieldLineFromSurface(particle2.geometry.parameters.radius, 0.2);

const camera = new THREE.PerspectiveCamera(75, canvasWidth / canvasHeight, 0.01, 10);
camera.position.set(0.03, 0.03, 0.1);
// camera.lookAt(0.03, 0, 0);
scene.add(camera);

const renderer = new THREE.WebGLRenderer({ canvas, antialias: true });
renderer.setClearColor(0xfafafa, 1);
renderer.setSize(canvasWidth, canvasHeight, false);
renderer.render(scene, camera);

const orbitControl = new OrbitControls(camera, canvas);
// console.log(renderer.domElement);
orbitControl.target.set(0.03, 0, 0);
// 设置控制器的目标点
orbitControl.update();

const gui = new GUI({ container: canvasWrapper });
setGUIinWrapper(gui, canvasWrapper, orbitControl);

window.addEventListener("resize", () => {
  onResize(canvas, dpr, camera, renderer);
});

// 监听元素全屏变化
document.addEventListener("fullscreenchange", () => {
  // 稍微延迟，确保全屏样式已应用
  setTimeout(() => onResize(canvas, dpr, camera, renderer), 100);
});

const targetFPS = 10;
const frameInterval = 1000 / targetFPS;
let lastFrameTime = 0;

let animationId = null;  // 保存 requestAnimationFrame 的 ID
let isVisible = true;    // 标记元素是否可见


function animate(currentTime) {
 animationId = requestAnimationFrame(animate);

  const deltaTime = currentTime - lastFrameTime;
  if (deltaTime < frameInterval) return;
  console.log(currentTime);

  lastFrameTime = currentTime - (deltaTime % frameInterval);
  // 将 lastFrameTime 对齐到理论帧时间点（frameInterval的整数倍）
  // 避免因帧率波动导致的渲染时间点漂移
  // 长效果：长期保持平均 21 FPS，避免误差累积

  orbitControl.update();
  renderer.render(scene, camera);
}

animationId = requestAnimationFrame(animate);


// 使用 Intersection Observer 监听可见性
const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      // 元素进入可视区域，恢复动画
      if (!isVisible) {
        isVisible = true;
        lastFrameTime = performance.now(); // 重置时间，避免跳帧
        animationId = requestAnimationFrame(animate);
      }
    } else {
      // 元素离开可视区域，停止动画
      if (isVisible) {
        isVisible = false;
        if (animationId !== null) {
          cancelAnimationFrame(animationId);
          animationId = null;
        }
      }
    }
  });
}, {
  threshold: 0 // 当元素有任何部分不可见时触发
});

// 开始观察 canvasWrapper
observer.observe(canvasWrapper);

