import uuidv4 from 'uuid/v4'

export default {
  /**
   * findAll
   * @param schema
   * @param where
   * @returns {*|Promise<Array<Model>>}
   */
  findAll: (schema, where = {}) => schema.findAll({ where }),

  /**
   * findOne
   * @param schema
   * @param where
   * @returns {*|Promise<Model>}
   */
  findOne: (schema, where) => schema.findOne({ where }),

  /**
   * create
   * @param schema
   * @param context
   * @returns {*}
   */
  create: (schema, context) => {
    const hoge = Object.assign({ id: uuidv4() }, context)
    console.log('Hola', hoge)
    return schema.create(hoge)
  },

  /**
   * update
   * @param schema
   * @param where
   * @param context
   * @returns {*}
   */
  update: (schema, where, context) => schema.update(context, { where }),

  /**
   * destroy
   * @param schema
   * @param id
   * @returns {*}
   */
  destroy: (schema, id) => schema.destroy({ where: { id } })
}
