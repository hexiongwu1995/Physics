// 绘制电场线，模拟两个点电荷在空间产生的电场

import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";
import { constants } from "fundamental-physical-constants";
import { GUI } from "three/addons/libs/lil-gui.module.min.js";
import { setCanvasSize, setGUIinWrapper, onResize } from "./three/setting.js";

// =====================================================

const canvasWrapper = document.querySelector("#electric-field-wrapper");
const canvas = document.querySelector("#electric-field-canvas");

setCanvasSize(canvas);
const canvasWidth = canvas.width;
const canvasHeight = canvas.height;

const scene = new THREE.Scene();

const camera = new THREE.PerspectiveCamera(75, canvasWidth / canvasHeight, 0.01, 100);
scene.add(camera);
camera.position.set(0.03, 0, 0.25);
camera.lookAt(0.03, 0, 0);

const ambientLight = new THREE.AmbientLight(0xffffff, 0.1);
scene.add(ambientLight);

const pointLight = new THREE.PointLight(0xffffff, 0.008, 0.2);
scene.add(pointLight);
pointLight.position.copy(camera.position);

const renderer = new THREE.WebGLRenderer({ canvas, antialias: true });
renderer.setClearColor(0xfafafa, 1);
renderer.setSize(canvasWidth, canvasHeight, false);
renderer.render(scene, camera);

const orbitControl = new OrbitControls(camera, canvas);
orbitControl.target.set(0.03, 0, 0);
orbitControl.enablePan = false;
orbitControl.update();

const gui = new GUI({ container: canvasWrapper });
setGUIinWrapper(gui, canvasWrapper, orbitControl);

// =====================================================

// const axesHelper = new THREE.AxesHelper(0.12);
// scene.add(axesHelper);

// const gridHelper = new THREE.GridHelper(0.2, 10);
// scene.add(gridHelper);

const particle1 = new THREE.Mesh(new THREE.SphereGeometry(0.003, 16, 16), new THREE.MeshStandardMaterial({ color: 0xff0000, opacity: 1, transparent: true }));
particle1.position.set(0, 0, 0);
scene.add(particle1);

const particle2 = new THREE.Mesh(new THREE.SphereGeometry(0.003, 16, 16), new THREE.MeshStandardMaterial({ color: 0x00ff00, opacity: 1, transparent: true }));
particle2.position.set(0.06, 0, 0);
scene.add(particle2);

const vacuumElectricPermittivity = constants["vacuum electric permittivity"].value;

const k = 1 / (4 * Math.PI * vacuumElectricPermittivity);
let particle1Charge = 4.0e-8;
let particle2Charge = -1.0e-8;
let distance = 0.06;

// 以y轴为极轴生成球面采样点
// applyAxisAngle 旋转到x轴为极轴的位置
function generateParticleSurfacePoints(particle, particleCharge, segments = {}) {
  const chargeFraction = Math.abs(particleCharge) / (Math.abs(particle1Charge) + Math.abs(particle2Charge));
  let { phiSegments = 50, thetaSegments = 2 } = segments;
  phiSegments = Math.floor(chargeFraction * phiSegments);
  let surfacePoints = [];
  const radius = particle.geometry.parameters.radius;
  for (let i = 0; i <= phiSegments; i++) {
    for (let j = 0; j <= thetaSegments; j++) {
      let phi = (i * Math.PI) / phiSegments;
      let theta = ((j - thetaSegments / 4) / thetaSegments) * 2 * Math.PI;
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

function getParticleElectricField(particle, particleCharge, position) {
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

// 获取电场线的点集
function traceFieldLineFromParticle(particle, segments, particleCharge, otherParticles, stepLength, maxLength) {
  let fieldLinesDataFromParticle = [];
  let particleRadius = particle.geometry.parameters.radius;
  let otherParticlesRadius = otherParticles.geometry.parameters.radius;
  let particleSurfacePoints = generateParticleSurfacePoints(particle, particleCharge, segments);

  for (let i = 0; i < particleSurfacePoints.length; i++) {
    let fieldLine = [];
    let startPoint = particleSurfacePoints[i].clone();
    fieldLine.push(startPoint);
    let drawDirection = getSpaceElectricField(startPoint).normalize().multiplyScalar(Math.sign(particleCharge));
    let currentPoint = startPoint.clone().add(drawDirection.multiplyScalar(stepLength));

    while (!(currentPoint.distanceTo(particle.position) >= maxLength || currentPoint.distanceTo(otherParticles.position) <= otherParticlesRadius)) {

      let resetStepLength;
      if (currentPoint.distanceTo(otherParticles.position) <= 3 * otherParticlesRadius || currentPoint.distanceTo(particle.position) <= 3 * particleRadius) {
        resetStepLength = Math.min(particleRadius, otherParticlesRadius) / 5;
      } else {
        resetStepLength = stepLength;
      }
      startPoint = currentPoint.clone();
      fieldLine.push(startPoint);
      drawDirection = getSpaceElectricField(startPoint).normalize().multiplyScalar(Math.sign(particleCharge));
      currentPoint = startPoint.clone().add(drawDirection.multiplyScalar(resetStepLength));
    }
    fieldLine.push(currentPoint);
    fieldLinesDataFromParticle.push(fieldLine);
  }
  return fieldLinesDataFromParticle;
}

let fieldLineObjects = [];

function drawFieldLines(fieldLinesData, particleCharge, color) {
  fieldLinesData.forEach((fieldLine) => {
    const lineGeometry = new THREE.BufferGeometry().setFromPoints(fieldLine);
    const lineMaterial = new THREE.LineBasicMaterial({ color: color });
    const line = new THREE.Line(lineGeometry, lineMaterial);
    scene.add(line);
    fieldLineObjects.push(line);

    const arrayLength = fieldLine.length;
    const middleIndex = Math.floor(arrayLength / 2);
    const direction = fieldLine[middleIndex]
      .clone()
      .sub(fieldLine[middleIndex - 1])
      .normalize()
      .multiplyScalar(Math.sign(particleCharge));

    const coneGeometry = new THREE.ConeGeometry(0.001, 0.005, 10, 1, false);
    const coneMaterial = new THREE.MeshBasicMaterial({
      color: color,
    });
    const cone = new THREE.Mesh(coneGeometry, coneMaterial);
    const up = new THREE.Vector3(0, 1, 0);
    const quaternion = new THREE.Quaternion().setFromUnitVectors(up, direction);
    cone.setRotationFromQuaternion(quaternion);
    cone.position.set(fieldLine[middleIndex].x, fieldLine[middleIndex].y, fieldLine[middleIndex].z);
    scene.add(cone);
    fieldLineObjects.push(cone);
  });
}

// let LinesPerUnitCharge, chargeRatio, LineNumFromParticle1, LineNumFromParticle2;

// 定义基准：单位电荷对应的穿过包围该电荷的封闭曲面的电场线数
// function resetLinesPerUnitCharge(N) {
//   LinesPerUnitCharge = N; // 2.0e9
//   LineNumFromParticle1 = Math.abs(LinesPerUnitCharge * particle1Charge);
//   LineNumFromParticle2 = Math.abs(LinesPerUnitCharge * particle2Charge);
// }

function clearFieldLines() {
  if (fieldLineObjects.length === 0) return;
  fieldLineObjects.forEach((obj) => {
    scene.remove(obj);
    if (obj.geometry) obj.geometry.dispose();
    if (obj.material) obj.material.dispose();
  });
  fieldLineObjects = [];
}

let segments = {
  phiSegments: 100,
  thetaSegments: 2,
};

function traceParticle1() {
  const fieldLinesDataFromParticle1 = traceFieldLineFromParticle(particle1, segments, particle1Charge, particle2, particle1.geometry.parameters.radius, distance * 3);
  drawFieldLines(fieldLinesDataFromParticle1, particle1Charge, 0xccaaaa);
}

function traceParticle2() {
  const fieldLinesDataFromParticle2 = traceFieldLineFromParticle(particle2, segments, particle2Charge, particle1, particle2.geometry.parameters.radius, distance * 3);
  drawFieldLines(fieldLinesDataFromParticle2, particle2Charge, 0xaaccaa);
}

function updateFieldLines() {
  clearFieldLines();
  traceParticle1();
  traceParticle2();
}

updateFieldLines();

const chargeValues = [-5.0e-8, -4.0e-8, -3.0e-8, -2.0e-8, -1.0e-8, 1.0e-8, 2.0e-8, 3.0e-8, 4.0e-8, 5.0e-8];

const chargeFolder = gui.addFolder("Charge");
chargeFolder
  .add({ value: particle1Charge }, "value", chargeValues)
  .name("Particle1 Charge")
  .onChange((v) => {
    particle1Charge = v;
    updateFieldLines();
  });
chargeFolder
  .add({ value: particle2Charge }, "value", chargeValues)
  .name("Particle2 Charge")
  .onChange((v) => {
    particle2Charge = v;
    updateFieldLines();
  });

const fieldLineNumbersFolder = gui.addFolder("FieldLineNumbers");
fieldLineNumbersFolder.add(segments, "phiSegments", 10, 100, 1).name("phiSegments").onChange(updateFieldLines);
fieldLineNumbersFolder.add(segments, "thetaSegments", 1, 20, 1).name("thetaSegments").onChange(updateFieldLines);

const cameraPosition = {
  topView: function () {
    camera.position.set(0.03, 0.25, 0);
    orbitControl.update();
  },
  frontView: function () {
    camera.position.set(0.03, 0, 0.25);
    orbitControl.update();
  },
  rightView: function () {
    camera.position.set(0.25, 0, 0);
    orbitControl.update();
  },
};

const cameraFolder = gui.addFolder("CameraPosition");
cameraFolder.add(cameraPosition, "topView").name("Top View");
cameraFolder.add(cameraPosition, "frontView").name("Front View");
cameraFolder.add(cameraPosition, "rightView").name("Right View");

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