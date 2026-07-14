document.getElementById('buscar_button').addEventListener('click', () => {
    let busca = document.getElementById("busca").value;
    if(busca !== ''){busca = `&busca=${busca}`}
    const user_id = new URLSearchParams(window.location.search).get('id_usuario')
    window.location.href = `${window.location.origin}/?id_usuario=${user_id}${busca}`
})