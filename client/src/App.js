import React, { Component } from 'react';
import { Container, Header, Table } from 'semantic-ui-react'
import './App.css';

class App extends Component {
  constructor() {
    super()
    this.state = {}
    this.getFilms = this.getFilms.bind(this)
  }

  componentDidMount() {
    this.getFilms()
  }

  fetch(url) {
    return window.fetch(url)
      .then(response => response.json())
      .catch(error => console.log(error))
  }

  getFilms() {
    this.fetch('/api/v1/films')
      .then(films => {
        if (films.length) {
          this.setState({films: films})
        } else {
          this.setState({films: []})
        }
      })
  }

  render() {
    const films = this.state.films
    console.log(films);
    return (
      <Container text>
        <Header as='h2'>
          <Header.Content>Now Playing</Header.Content>
        </Header>
        { films && films.length &&
          <Container>
            <Table celled>
              <Table.Header>
                <Table.Row>
                  <Table.HeaderCell>Film</Table.HeaderCell>
                  <Table.HeaderCell>Times</Table.HeaderCell>
                </Table.Row>
              </Table.Header>
              <Table.Body>
                {films.map((film) =>
                  <Table.Row>
                    <Table.Cell>{film.title}</Table.Cell>
                    <Table.Cell>{film.times2d} {film.times3d}</Table.Cell>
                  </Table.Row>
                )}
              </Table.Body>
            </Table>
          </Container>
        }
      </Container>
    );
  }
}

export default App;
