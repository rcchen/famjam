'use strict';

import React, {
  CameraRoll,
  DeviceEventEmitter,
  Text,
  TouchableWithoutFeedback,
  View
} from 'react-native';

var ImagePickerManager = require('NativeModules').ImagePickerManager;
var RNUploader = require('NativeModules').RNUploader;

var Progress = require('react-native-progress');

import { BASE_URL, fetchSignedUploadUrl, fetchTopic } from "../app/services";
import { LetterCircle } from "../components/letterCircle";

var token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiI1NzFiYjkzZjg1YzZiNTExMDA1MjI4ODAiLCJpYXQiOjE0NjE3NDU5NDh9.xUlHWLUAk_cgn_T5oLdWJ0oeFJIQ6IXsqOLZR02hr2o";

var styles = React.StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FAFAFA',
    top: 20
  },
  square: {
    width: 100,
    height: 100
  },
  progress: {
    margin: 10
  },
  circles: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  participants: {
    alignItems: "center",
    flexDirection: "row"
  }
});

export default class TopicView extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      progress: 0,
      topic: null,
      uploadUrl: null,
      users: []
    };
  }

  render() {
    console.log(this.state.uploadUrl);
    if (this.state.topic) {
      const colors = ["#F44336", "#2196F3", "#009688", "#FF5722", "#388E3C"];
      const topic = this.state.topic;
      const users = topic.users.slice();
      users.push(topic._creator);

      console.log(topic.photos);

      const userCircles = users.map((user, index) => {
        const color = colors[index % colors.length];
        return (
          <LetterCircle
            backgroundColor={color}
            color="white"
            label={user.username}
          />
        );
      });

      return (
        <View style={styles.container}>
          <Text>{topic.name}</Text>
          <Progress.Circle size={100} progress={this.state.progress} />
          <TouchableWithoutFeedback onPress={this.increment}>
            <Text>Increment</Text>
          </TouchableWithoutFeedback>
          <TouchableWithoutFeedback onPress={this.selectPhoto}>
            <Text>Upload</Text>
          </TouchableWithoutFeedback>
          <View style={styles.participants}>
            { userCircles }
          </View>

          <View style={styles.square}>

          </View>

        </View>
      );
    } else {
      return (
        <View style={styles.container}>
          <TouchableWithoutFeedback onPress={this.setTopic}>
            <Text>This is a simple application.</Text>
          </TouchableWithoutFeedback>
          <View style={styles.circles}>
            <Progress.CircleSnail
              color={['red', 'green', 'blue']}
              style={styles.progress}
            />
          </View>
        </View>
      )
    }
  }

  componentDidMount() {
    this.attachListeners();
    this.setTopic();
  }

  attachListeners = () => {
    // upload progress
    DeviceEventEmitter.addListener('RNUploaderProgress', (data)=>{
      let bytesWritten = data.totalBytesWritten;
      let bytesTotal   = data.totalBytesExpectedToWrite;
      let progress     = data.progress;

      console.log( "upload progress: " + progress + "%");
    });
  }

  increment = () => {
    this.setState({
      progress: this.state.progress + 0.1
    });
  }

  setTopic = () => {
    fetchTopic(this.props.id, token)
      .then((topic) => {
        this.setState({
          topic: topic
        });
      })
      .catch((error) => {
        console.log(error);
      });
  }

  selectPhoto = () => {
    const options = {
      title: 'Photo Picker',
      takePhotoButtonTitle: 'Take Photo...',
      chooseFromLibraryButtonTitle: 'Choose from Library...',
      quality: 0.5,
      maxWidth: 300,
      maxHeight: 300,
      storageOptions: {
        skipBackup: true
      },
      allowsEditing: true
    };

    ImagePickerManager.showImagePicker(options, (response) => {
      if (response.didCancel) {
        console.log('User cancelled image picker');
      }
      else if (response.error) {
        console.log('ImagePickerManager Error: ', response.error);
      }
      else if (response.customButton) {
        console.log('User tapped custom button: ', response.customButton);
      }

      else {
        this.uploadPhoto(response);
      }
    });
  };

  uploadPhoto = (response) => {
    console.log(response);
    const files = [
      {
        name: "photo",
        filename: "image.jpg",
        filepath: response.origURL,
        filetype: "image/jpeg"
      }
    ];
    const options = {
      url: BASE_URL + "/topics/" + this.props.id,
      files: files,
      method: "POST",
      headers: {
        "Authorization": "Bearer " + token
      },
      params: {
        "description": "ffffuuuuuuuuuuu"
      }
    }

    RNUploader.upload(options, (err, response) => {
        if( err ){
            console.log(err);
            return;
        }

        console.log(response);

        let status = response.status;

        console.log('upload complete with status ' + status);
    });
  };
}
