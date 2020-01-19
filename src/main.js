const rootNode = document.getElementById('app');

rootNode.textContent = 'Hello World';

fetch('/api/msg')
  .then(res => res.json())
  .then(body => {
    if (body.text) {
      const node = document.createElement('p');
      node.textContent = 'Get value from api: ' + body.text;
      rootNode.appendChild(node);
    }
  })
  .catch(e => console.error(e));
