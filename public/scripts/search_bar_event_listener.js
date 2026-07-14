document.getElementById('buscar_button').addEventListener('click', () => {
    const busca = document.getElementById("busca").value;
    if(window.location.href.includes('?')){
        window.location.href += `&busca=${busca}`
    }
    else{
        window.location.href += `?busca=${busca}`
    }
})