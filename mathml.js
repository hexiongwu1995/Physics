function scaleMathFormulas() {
  document.querySelectorAll('math[display="block"]').forEach(math => {
    const parent = math.parentElement;
    const mathWidth = math.scrollWidth;
    const parentWidth = parent.clientWidth;
    
    if (mathWidth > parentWidth) {
      const scale = parentWidth / mathWidth;
      math.style.transform = `scale(${scale})`;
      // 调整下方间距，因为 scale 后元素占据的原空间不变
      math.style.marginBottom = `-${math.offsetHeight * (1 - scale)}px`;
    } else {
      math.style.transform = 'none';
      math.style.marginBottom = '0';
    }
  });
}

// 初始化时和窗口大小变化时执行
window.addEventListener('load', scaleMathFormulas);
window.addEventListener('resize', scaleMathFormulas);