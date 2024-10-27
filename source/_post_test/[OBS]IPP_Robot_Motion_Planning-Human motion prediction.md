---
aliases: null
date:
- 2023-05-09 21:58:07
tags:
- RNN
title: Human_motion_prediction
toc: true

---

# Materials

[compilations](https://github.com/karttikeya/awesome-human-pose-prediction)

## Dataset

### H3.6m

[Human3.6M](http://vision.imar.ro/human3.6m/description.php)

[Parse](https://blog.csdn.net/alickr/article/details/107837403?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-107837403-blog-126380971.235%5Ev36%5Epc_relevant_default_base3&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-107837403-blog-126380971.235%5Ev36%5Epc_relevant_default_base3&utm_relevant_index=2)

[Paper](http://vision.imar.ro/human3.6m/pami-h36m.pdf)

## Depth camera

[Doc](https://lightbuzz.com/azure-kinect-unity/#:~:text=Azure%20Kinect%20is%20Microsoft%E2%80%99s%20latest%20depth)



---

# Human motion prediction using recurrent neural networks

[Repository](https://github.com/enriccorona/human-motion-prediction-pytorch)
[Paper](https://arxiv.org/pdf/1705.02445.pdf)

## Input

*raw data* : for each subjects(S1,S2 ...) , each action(walking, waiting, smoking ...), each sub sequence(1/2):
$(n) \times 99$ (np.ndarray, float32)

#### From `data_utils.load_data()` used by `translate.read_all_data()`

*train data*: the composed dictionary ((suject_id, action, subaction_id, 'even') as key) of raw data (just even rows), with one hot encoding columns for action type, if action is specified (normal case), just append an all 1 column to rawdata. Size of each dictionary value: 
$(n/2) \times (99 + actions\;count)$

*complete data*: all data joint together, from different subjects, actions, sub sequences:
$(n) \times 99$

#### From `translate.read_all_data()` used by `translate.train()`

*train set* : normalized *train data*, throw out data with $std < 1e-4$ (accroding to *complete data*). Size of each dictionary value: 
$(n/2) \times ((99-used\;dimension\;count) + actions\;count)$

#### Human Dimension

After the analyzztion of the *complete data*, human dimension has been fixed to $54$.

#### From `Seq2SeqModel.get_batch()` used by `translate.train()`


*total_seq*: $60$ ($[0,59]$)
>*source_seq_len*: $50$
>*target_seq_len*: $10$

*batch_size*: $16$

*encoder_inputs*: $16\times 49\times (54+actions\;count)$
Interpretation: \[*batch*,*frame*,*dimension*\]
*frame* range: $[0,48]$

*decoder_inputs*: $16\times 10\times (54+actions\;count)$
*frame* range: $[49,58]$

*decoder_outputs*: $16\times 10\times (54+actions\;count)$
*frame* range: $[50,59]$

#### Model prediction input

*encoder_inputs*: Tensor form of *encoder_inputs* from `Seq2SeqModel.get_batch()`
```python
torch.from_numpy(encoder_inputs).float()
```

*decoder_inputs*: Tensor form of *decoder_inputs* from `Seq2SeqModel.get_batch()`


## Example

For detailed usage, please see `[Adopted] human-motion-prediction-pytorch\src\predict.ipynb`

## Reminder

The kinect camera's output is not guaranteed to be consistent with the input of this model (some features are cut off), so further research is needed.

# Pykinect

Run `pyKinectAzure\examples\exampleBodyTrackingTransformationComparison` to get the camera output record in `pyKinectAzure\saved_data`, saved as `.npy`