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
    var sources = [
      'https://www.cinemaclock.com/theatres/galaxy-nanaimo',
      'https://www.cinemaclock.com/theatres/avalon',
    ]
    this.setState({films: []})
    sources.map((url) => {
      this.fetch('/api/v1/films?source='+url)
        .then(films => {
          var all_films = this.state.films.concat(films)
          all_films.sort((film1, film2) => {
            return (film1.title < film2.title) ? -1 : 1
          })
          if (films.length) {
            this.setState({films: all_films})
          } else {
            this.setState({films: []})
          }
        })
      return '' // TODO: I really just want "each"
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
                  <Table.HeaderCell>Theatre</Table.HeaderCell>
                  <Table.HeaderCell>Times</Table.HeaderCell>
                </Table.Row>
              </Table.Header>
              <Table.Body>
                {films.map((film) =>
                  <Table.Row>
                    <Table.Cell>{film.title}</Table.Cell>
                    <Table.Cell>{film.theatre}</Table.Cell>
                    <Table.Cell>{(film.showings.map((showing) => {
                      return showing.time;
                    }).join(", "))}</Table.Cell>
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
