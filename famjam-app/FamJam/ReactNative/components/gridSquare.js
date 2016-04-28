'use strict';

import React, {
  Image,
  StyleSheet,
  Text,
  View
} from 'react-native';

import { LetterCircle } from "./letterCircle";

export class GridSquare extends React.Component {
  render() {
    const blurRadius = this.props.hidden ? 35 : 0;
    return (
      <View style={styles.container}>
        <Image
          blurRadius={blurRadius}
          resizeMode="cover"
          source={{ uri: this.props.imageUri }}
          style={styles.image}
        />
        <Text style={styles.description}>{this.props.description}</Text>
        <View style={styles.letterCircle}>
          <LetterCircle
            backgroundColor={this.props.color}
            color="#FFFFFF"
            label={this.props.username}
          />
        </View>
      </View>
    );
  }
}

var styles = React.StyleSheet.create({
  container: {
    borderColor: "#B0BEC5",
    borderWidth: 1,
    height: 237,
    marginHorizontal: 3,
    marginVertical: 5,
    width: 175
  },
  description: {
    backgroundColor: "#FFFFFF",
    paddingHorizontal: 10,
    paddingVertical: 15,
    paddingTop: 30
  },
  image: {
    backgroundColor: "#CFD8DC",
    height: 173,
    width: 173
  },
  letterCircle: {
    position: "absolute",
    bottom: 42,
    left: 55
  }
});
