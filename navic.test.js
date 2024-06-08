function hola(param) {
  const foo = 'bar' + param

  function chao() {
    const bar = foo
    const x = null

    return bar + x
  }

  for (let i = 0; i < 10; i++) {
    console.log(chao())
  }

  if (foo === 'bar' && param === 'hello') {
    return 'Chao'
  }
  return 'Hola'
}

hola('hello')
