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

const ambientLight = new THREE.AmbientLight(0xffffff, 0.1);
scene.add(ambientLight);

const particle1 = new THREE.Mesh(new THREE.SphereGeometry(0.003, 16, 16), new THREE.MeshStandardMaterial({ color: 0xff0000, opacity: 1, transparent: true }));
particle1.position.set(0, 0, 0);
scene.add(particle1);

const particle2 = new THREE.Mesh(new THREE.SphereGeometry(0.003, 16, 16), new THREE.MeshStandardMaterial({ color: 0x00ff00, opacity: 1, transparent: true }));
particle2.position.set(0.06, 0, 0);
scene.add(particle2);

const vacuumElectricPermittivity = constants["vacuum electric permittivity"].value;

const k = 1 / (4 * Math.PI * vacuumElectricPermittivity);
const particle1Charge = 4.0e-8;
const particle2Charge = -1.0e-8;
const distance = 0.06;

const electricForce = (k * particle1Charge * particle2Charge) / distance ** 2;

// textElement.innerHTML = `静电力常数： ${k.toExponential(2)} N m^2 / C^2 <br> 两个电荷之间的静电力： ${electricForce.toExponential(2)} N `;

// 以y轴为极轴生成球面采样点
function generateParticleSurfacePoints(particle, options = {}) {
  const { phiSegments = 15, thetaSegments = 10 } = options;
  let surfacePoints = [];
  const radius = particle.geometry.parameters.radius;
  for (let i = 0; i <= phiSegments; i++) {
    for (let j = 0; j <= thetaSegments; j++) {
      let phi = (i * Math.PI) / phiSegments;
      let theta = (j * 2 * Math.PI) / thetaSegments;
      let surfacePoint = new THREE.Vector3();
      surfacePoint
        .setFromSphericalCoords(radius, phi, theta)
        .applyAxisAngle(new THREE.Vector3(0, 0, 1), -Math.PI / 2)
        .add(particle.position);
      surfacePoints.push(surfacePoint);
    }
  }
  return surfacePoints;
}

// 以x轴为极轴生成球面采样点
// function generateParticleSurfacePoints(particle, xdivisions = 5, angledivisions = 10){
//   let surfacePoints = [];
//   const sphereRadius = particle.geometry.parameters.radius;
//   for (let i = 0; i <= 2 * xdivisions; i++){
//     let x = (i - xdivisions)/ xdivisions * sphereRadius;
//     for (let j=0; j<= angledivisions; j++){
//       let circleRadius = Math.sqrt(sphereRadius ** 2 - x ** 2);
//       let angle = j / angledivisions * 2 * Math.PI;
//       let y = circleRadius * Math.cos(angle);
//       let z = circleRadius * Math.sin(angle);
//       let surfacePoint = new THREE.Vector3();
//       surfacePoint.set(x, y, z).add(particle.position);
//       surfacePoints.push(surfacePoint);
//     }
//   }
//   return surfacePoints;
// }

function getParticleElectricField(particle, particleCharge, position) {
  // 来自particle的电场
  let field = new THREE.Vector3();
  const distance = position.distanceTo(particle.position);
  field = position
    .clone()
    .sub(particle.position)
    .normalize()
    .multiplyScalar((k * particleCharge) / distance ** 2);
  return field;
}

function getSpaceElectricField(position) {
  let field = new THREE.Vector3();
  field.add(getParticleElectricField(particle1, particle1Charge, position));
  field.add(getParticleElectricField(particle2, particle2Charge, position));
  return field;
}

let fieldLines = [];

function traceFieldLineFromParticle(particle, particleCharge, phiSegments, thetaSegments, color, otherParticles, stepLength, maxLength) {
  let particleSurfacePoints = generateParticleSurfacePoints(particle);

  for (let i = 0; i < particleSurfacePoints.length; i++) {
    let fieldLine = [];
    let startPoint = particleSurfacePoints[i].clone();
    fieldLine.push(startPoint);
    let drawDirection = getSpaceElectricField(startPoint).normalize().multiplyScalar(Math.sign(particleCharge));
    let currentPoint = startPoint.clone().add(drawDirection.multiplyScalar(stepLength));

    while (!(currentPoint.distanceTo(particle.position) >= maxLength || currentPoint.distanceTo(otherParticles.position) <= otherParticles.geometry.parameters.radius)) {
      startPoint = currentPoint.clone();
      fieldLine.push(startPoint);
      drawDirection = getSpaceElectricField(startPoint).normalize().multiplyScalar(Math.sign(particleCharge));
      currentPoint = currentPoint.clone().add(drawDirection.multiplyScalar(stepLength));
    }
    fieldLine.push(currentPoint);
    fieldLines.push(fieldLine);
  }
}

traceFieldLineFromParticle(particle1, particle1Charge, 8, 8, 0xff0000, particle2, 0.002, 0.2);
// traceFieldLineFromParticle(particle2, particle2Charge, 8, 8, 0x00ff00, particle1, 0.002, 0.1);

fieldLines.forEach((fieldLine) => {
  const lineGeometry = new THREE.BufferGeometry().setFromPoints(fieldLine);
  const lineMaterial = new THREE.LineBasicMaterial({ color: 0xaaaaaa });

  const line = new THREE.Line(lineGeometry, lineMaterial);
  scene.add(line);
  const arrayLength = fieldLine.length;
  const middleIndex = Math.floor(arrayLength / 2);
  const direction = fieldLine[middleIndex]
    .clone()
    .sub(fieldLine[middleIndex - 1])
    .normalize();

  const coneGeometry = new THREE.ConeGeometry(0.0005, 0.002, 10);
  const coneMaterial = new THREE.MeshStandardMaterial({
    color: 0xbbbbbb,
    roughness: 0.1,
    metalness: 0.1,
  });
  const cone = new THREE.Mesh(coneGeometry, coneMaterial);
  const up = new THREE.Vector3(0, 1, 0);
  const quaternion = new THREE.Quaternion().setFromUnitVectors(up, direction);
  cone.setRotationFromQuaternion(quaternion);
  cone.position.set(fieldLine[middleIndex].x, fieldLine[middleIndex].y, fieldLine[middleIndex].z);
  scene.add(cone);
});

const camera = new THREE.PerspectiveCamera(75, canvasWidth / canvasHeight, 0.01, 10);
camera.position.set(0.03, 0.03, 0.1);
// camera.lookAt(0.03, 0, 0);
scene.add(camera);

const pointLight = new THREE.PointLight(0xffffff, 0.005, 0.2);
pointLight.position.copy(camera.position);
scene.add(pointLight);

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

let animationId = null; // 保存 requestAnimationFrame 的 ID
let isVisible = false; // 标记元素是否可见

function animate(currentTime) {
  animationId = requestAnimationFrame(animate);

  const deltaTime = currentTime - lastFrameTime;
  if (deltaTime < frameInterval) return;
  // console.log(currentTime);

  lastFrameTime = currentTime - (deltaTime % frameInterval);
  // 将 lastFrameTime 对齐到理论帧时间点（frameInterval的整数倍）
  // 避免因帧率波动导致的渲染时间点漂移
  // 长效果：长期保持平均 21 FPS，避免误差累积

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
    rootMargin: "10px", // 表示视口外10px触发可见
    threshold: 0, // 观察的阈值
    // 阈值为0表示当元素开始进入视口时触发可见，当元素完全离开视口时触发不可见
    // 进入视口时运行一次回调函数，离开视口时再运行一次回调函数，中间过程不运行回调函数
  },
);

// 开始观察 canvasWrapper
observer.observe(canvasWrapper);