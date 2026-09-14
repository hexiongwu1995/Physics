// 绘制电场线，模拟两个点电荷在空间产生的电场

import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";
import {constants} from "../FundamentalPhysicalConstants.js";

const dpi = window.devicePixelRatio;
const canvas = document.querySelector("#electric-field-canvas");
canvas.width = canvas.clientWidth * dpi;
canvas.height = canvas.clientHeight * dpi;
const canvasWidth = canvas.width;
const canvasHeight = canvas.height;

const scene = new THREE.Scene();

const axesHelper = new THREE.AxesHelper(0.15);
scene.add(axesHelper);

const gridHelper = new THREE.GridHelper(0.2, 10);
scene.add(gridHelper);

const particle1 = new THREE.Mesh(new THREE.SphereGeometry(0.002, 16, 16), new THREE.MeshBasicMaterial({ color: 0xff0000 }));
particle1.position.set(0, 0, 0);
scene.add(particle1);

const particle2 = new THREE.Mesh(new THREE.SphereGeometry(0.002, 16, 16), new THREE.MeshBasicMaterial({ color: 0x00ff00 }));
particle2.position.set(0.06, 0, 0);
scene.add(particle2);

const electricConstant = constants["vacuum electric permittivity"].value;

const k = 1 / (4 * Math.PI * electricConstant[0]);
const particle1Charge = 4.0e-8;
const particle2Charge = -1.0e-8;
const distance = 0.06;

const electricForce = k * particle1Charge * particle2Charge / distance ** 2;
console.log("静电力常数：",k.toExponential(2))
console.log("两个电荷之间的静电力：",electricForce.toExponential(2), 'N')

// const aValue = constants["Rydberg constant times hc in J"].value;


const camera = new THREE.PerspectiveCamera(75, canvasWidth / canvasHeight, 0.01, 10);
camera.position.set(0.03, 0, 0.1);
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

window.addEventListener("resize", () => {
  canvas.width = canvas.clientWidth * dpi;
  canvas.height = canvas.clientHeight * dpi;
  const canvasWidth = canvas.width;
  const canvasHeight = canvas.height;
  camera.aspect = canvasWidth / canvasHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(canvasWidth, canvasHeight, false);
});

function animate() {
  orbitControl.update();
  renderer.render(scene, camera);
  requestAnimationFrame(animate);
}

animate();
