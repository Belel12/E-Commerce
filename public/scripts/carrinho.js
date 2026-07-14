import { newForm, newHiddenInput } from "./element_factory.js";
/*
TODO: colocar opção para selecionar a quantidade que deseja remover ao inves de tudo de uma vez
 */

window.removerItemCarrinho = function(id_usuario, id_item){
    const input_id_item = newHiddenInput('id_item',id_item)

    const form= newForm(
        '/remover_item_carrinho',
        [input_id_item]
    )

    document.body.appendChild(form)
    form.submit()
}

window.comprarItensCarrinho = function (id_usuario){
    const input_id_usuario = newHiddenInput('id_usuario',id_usuario)

    const itens_carrinho = document.getElementsByClassName('cart-item')
    const quantidade_itens = document.getElementsByClassName('quantidade')

    const input_id_produto = []
    const input_quantidade_produtos = []

    //esse laço monta o array de ids dos produtos no carrinho
    // para cada produto
    for(let item of itens_carrinho){
        const input_id = newHiddenInput(
            'ids_produto[]',
            item.getAttribute('id')
        )
        console.log(input_id)
        input_id_produto.push(input_id)
    }

    // esse monta o array com as quantidades
    for(let quantidade of quantidade_itens){
        const input_quantidade = newHiddenInput(
            'quantidade_produtos[]',
            quantidade.getAttribute('id')
        )
        console.log(input_quantidade)
        input_quantidade_produtos.push(input_quantidade)
    }

    const form  = newForm(
        '/comprar',
        [input_id_usuario,...input_id_produto,...input_quantidade_produtos]
    )
    document.body.appendChild(form)
    form.submit()
}