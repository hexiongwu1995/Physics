// 绘制径向正弦波，模拟径向传播的波动

import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";
import { ParametricGeometry } from "three/addons/geometries/ParametricGeometry.js";
import { FontLoader } from "three/addons/loaders/FontLoader.js";
import { TextGeometry } from "three/addons/geometries/TextGeometry.js";
import { constants } from "fundamental-physical-constants";
import { GUI } from "three/addons/libs/lil-gui.module.min.js";
import { setCanvasSize, setGUIinWrapper, onResize } from "./setting.js";
import { createLine } from "./utils.js";

// =====================================================

const canvasWrapper = document.querySelector("#radial-sine-wave-wrapper");
const canvas = document.querySelector("#radial-sine-wave-canvas");

setCanvasSize(canvas);
const canvasWidth = canvas.width;
const canvasHeight = canvas.height;

const scene = new THREE.Scene();

const camera = new THREE.PerspectiveCamera(35, canvasWidth / canvasHeight, 0.01, 100);
// const camera = new THREE.OrthographicCamera(-1, 1, 1, -1, 0.01, 100);
scene.add(camera);
camera.position.set(0.5, 1, 3.5);
camera.lookAt(0, 0, 0);

const ambientLight = new THREE.AmbientLight(0xffffff, 1.5);
scene.add(ambientLight);

const pointLight = new THREE.PointLight(0xffffff, 1);
scene.add(pointLight);
pointLight.position.copy(camera.position);

const directionalLight = new THREE.DirectionalLight(0xffffff, 2);
scene.add(directionalLight);
directionalLight.position.copy(camera.position);

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
// 函数表达式：y = sin(sqrt(x^2 + z^2))

// 曲面参数
const surfaceParams = {
  range: 5, // x、z 的绘制范围均为 [-range, range]
  frequency: 1, // 径向波的角频率 ω，曲面为 y = sin(ω·sqrt(x² + z²))
  slices: 64, // u 方向（x 方向）的细分段数
  stacks: 64, // v 方向（z 方向）的细分段数
};

// camera.position.set(surfaceParams.range * 1.5, surfaceParams.range * 0.8, surfaceParams.range * 1.5);

// ParametricGeometry 的映射函数签名为 (u, v, target)：
// u、v 都在 [0, 1] 内均匀取样，target 是复用的 Vector3，
// 需要把 (u, v) 对应的曲面点写进 target（用 set，不要新建向量）
function radialSineWave(u, v, target) {
  const { range, frequency } = surfaceParams;
  const x = range * (2 * u - 1); // [0, 1] → [-range, range]
  const z = range * (2 * v - 1);
  const y = Math.sin(frequency * Math.sqrt(x * x + z * z));
  target.set(x / range, y / range, z / range);
}

function createSurfaceGeometry() {
  return new ParametricGeometry(radialSineWave, surfaceParams.slices, surfaceParams.stacks);
}

const surfaceMaterial = new THREE.MeshStandardMaterial({
  color: 0x2196f3,
  metalness: 0.3,
  roughness: 0.5,
  // 上述映射得到的法向量指向 -y，开启双面渲染后 three.js 会自动翻转背面法线，
  // 因此从上方俯视时同样能得到正确的光照
  side: THREE.DoubleSide,
});

const surfaceMesh = new THREE.Mesh(createSurfaceGeometry(), surfaceMaterial);
scene.add(surfaceMesh);
surfaceMesh.castShadow = true;
surfaceMesh.receiveShadow = true;

// ParametricGeometry 在构造时就把 (u, v) 的采样结果烘焙进顶点缓冲，
// 所以修改参数后必须重建几何体，并释放旧的 GPU 资源
function rebuildSurface() {
  surfaceMesh.geometry.dispose();
  surfaceMesh.geometry = createSurfaceGeometry();
}

const surfaceFolder = gui.addFolder("Radial Sine Wave");
surfaceFolder.add(surfaceParams, "frequency", 0.5, 6, 0.1).name("Frequency").onChange(rebuildSurface);
surfaceFolder.add(surfaceParams, "slices", 20, 128, 1).name("Slices (u)").onChange(rebuildSurface);
surfaceFolder.add(surfaceParams, "stacks", 20, 128, 1).name("Stacks (v)").onChange(rebuildSurface);
surfaceFolder.add(surfaceMaterial, "wireframe").name("Wireframe");
// ======================================================================
// const axesHelper = new THREE.AxesHelper(surfaceParams.range * 1.2);
// scene.add(axesHelper);

const gridHelper = new THREE.GridHelper(2, 20);
scene.add(gridHelper);

function createAxis() {
  const axisGroup = new THREE.Group();
  const xAxis = createLine(new THREE.Vector3(-1, 0, 0), new THREE.Vector3(1, 0, 0), { color: 0xaaaaaa, lineWidth: 0.005, headLengthRatio: 0.02, headWidthRatio: 0.01 });
  axisGroup.add(xAxis);
  const yAxis = createLine(new THREE.Vector3(0, -1, 0), new THREE.Vector3(0, 1, 0), { color: 0xaaaaaa, lineWidth: 0.005, headLengthRatio: 0.02, headWidthRatio: 0.01 });
  axisGroup.add(yAxis);
  const zAxis = createLine(new THREE.Vector3(0, 0, -1), new THREE.Vector3(0, 0, 1), { color: 0xaaaaaa, lineWidth: 0.005, headLengthRatio: 0.02, headWidthRatio: 0.01 });
  axisGroup.add(zAxis);
  scene.add(axisGroup);
}
createAxis();

let yLabelMesh = null;

async function initAxisLabels() {
  const loader = new FontLoader();
  const font = await loader.loadAsync("fonts/helvetiker_regular.typeface.json");

  const axisLabelGroup = new THREE.Group();

  for (const axisLabel of ["x", "y", "z"]) {
    const axisLabelGeometry = new TextGeometry(axisLabel, {
      font: font,
      size: 0.06, // 建议改小，80 太大了
      depth: 0.01,
      curveSegments: 12,
    });
    axisLabelGeometry.computeBoundingBox();
    const bbox = axisLabelGeometry.boundingBox;
    if (axisLabel == "x" || axisLabel == "z") {
      axisLabelGeometry.translate(0, -(bbox.min.y + bbox.max.y) / 2, 0);
    }
    if (axisLabel == "y") {
      axisLabelGeometry.translate(-(bbox.min.y + bbox.max.y) / 2, 0, 0);
    }

    const axisLabelMaterial = new THREE.MeshBasicMaterial({ color: 0xaaaaaa });
    const axisLabelMesh = new THREE.Mesh(axisLabelGeometry, axisLabelMaterial);
    axisLabelGroup.add(axisLabelMesh);
    if (axisLabel === "x") {
      axisLabelMesh.position.set(1.02, 0, 0);
    }
    if (axisLabel === "y") {
      axisLabelMesh.position.set(0, 1.02, 0);
      // axisLabelMesh.translate(0, -(bbox.min.y + bbox.max.y) / 2, 0);
      yLabelMesh = axisLabelMesh;
    }
    if (axisLabel === "z") {
      axisLabelMesh.position.set(0, 0, 1.04);
      axisLabelMesh.rotation.y = Math.PI / 2;
    }
  }
  scene.add(axisLabelGroup);
}
initAxisLabels();
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
  directionalLight.position.copy(camera.position);

  if (yLabelMesh) {
    const dx = camera.position.x - yLabelMesh.position.x;
    const dz = camera.position.z - yLabelMesh.position.z;
    yLabelMesh.rotation.y = Math.atan2(dx, dz);
  }

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
